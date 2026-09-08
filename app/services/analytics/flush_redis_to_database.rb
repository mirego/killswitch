module Analytics
  # Moves activity data from Redis into PostgreSQL.
  #
  # - Past dates (J-1 and older): counters are upserted into
  #   project_activity_dailies and then removed from Redis.
  # - Current day: counters stay in Redis; only projects.last_seen_at
  #   is persisted (see FlushLastSeenToDatabase).
  #
  # The upsert is additive (+= EXCLUDED.request_count), which makes the
  # flush idempotent even if it dies between the upsert and the Redis
  # cleanup, or if two flushes overlap.
  class FlushRedisToDatabase
    LOCK_KEY = 'analytics:flush_lock'.freeze
    LOCK_TTL = 240 # seconds

    class << self
      delegate :call, to: :new
    end

    def call
      return unless acquire_lock

      begin
        flush_past_dates
        FlushLastSeenToDatabase.call
      ensure
        release_lock
      end
    end

  private

    def acquire_lock
      KILLSWITCH_REDIS.set(LOCK_KEY, 1, nx: true, ex: LOCK_TTL)
    end

    def release_lock
      KILLSWITCH_REDIS.del(LOCK_KEY)
    end

    def flush_past_dates
      dates.each do |date|
        next unless Date.parse(date) < Date.current

        flush_date(date)
      end
    end

    def flush_date(date)
      counts = counters_for(date)
      return if counts.empty?

      upsert_counts(date, counts)
      cleanup_date(date, counts.keys)
    end

    # Returns { project_id (Integer) => request_count (Integer) }
    def counters_for(date)
      project_ids = KILLSWITCH_REDIS.smembers(tracker.active_projects_key(date))
      return {} if project_ids.empty?

      keys = project_ids.map { |id| tracker.counter_key(id, date) }
      values = KILLSWITCH_REDIS.mget(*keys)

      project_ids.map(&:to_i).zip(values.map(&:to_i)).to_h
    end

    def upsert_counts(date, counts)
      rows = counts.map do |project_id, request_count|
        { project_id:, date:, request_count:, created_at: Time.current, updated_at: Time.current }
      end

      # rubocop:disable Rails/SkipsModelValidations
      ProjectActivityDaily.upsert_all(
        rows,
        unique_by: %i(project_id date),
        on_duplicate: Arel.sql('request_count = project_activity_dailies.request_count + EXCLUDED.request_count, updated_at = EXCLUDED.updated_at')
      )
      # rubocop:enable Rails/SkipsModelValidations
    end

    def cleanup_date(date, project_ids)
      KILLSWITCH_REDIS.pipelined do |pipe|
        project_ids.each { |id| pipe.del(tracker.counter_key(id, date)) }
        pipe.del(tracker.active_projects_key(date))
        pipe.srem(tracker.active_dates_key, date)
      end
    end

    def dates
      KILLSWITCH_REDIS.smembers(tracker.active_dates_key)
    end

    def tracker
      Analytics::ProjectActivityTracker
    end
  end
end
