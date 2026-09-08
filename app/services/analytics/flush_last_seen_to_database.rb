module Analytics
  # Persists projects.last_seen_at from Redis into PostgreSQL.
  #
  # Writes are throttled: a project row is only updated when its
  # Redis-stored last_seen timestamp differs from the one we last
  # persisted (tracked in analytics:last_seen_db:*), so each flush
  # performs at most one UPDATE per project with fresh activity.
  class FlushLastSeenToDatabase
    LAST_SEEN_DB_TTL = 90.days.to_i
    UPDATE_BATCH_SIZE = 100

    class << self
      delegate :call, to: :new
    end

    def call
      project_ids = recently_active_project_ids
      return if project_ids.empty?

      last_seen = fetch_values(project_ids) { |id| tracker.last_seen_key(id) }
      last_seen_db = fetch_values(project_ids) { |id| last_seen_db_key(id) }

      stale_ids = project_ids.select do |id|
        last_seen[id].present? && last_seen[id] != last_seen_db[id]
      end

      stale_ids.each_slice(UPDATE_BATCH_SIZE) do |ids|
        update_projects(ids, last_seen)
        persist_last_seen_db(ids, last_seen)
      end
    end

  private

    def recently_active_project_ids
      dates = KILLSWITCH_REDIS.smembers(tracker.active_dates_key)

      dates.flat_map do |date|
        KILLSWITCH_REDIS.smembers(tracker.active_projects_key(date))
      end.uniq.map(&:to_i)
    end

    def fetch_values(project_ids, &)
      keys = project_ids.map(&)
      values = KILLSWITCH_REDIS.mget(*keys)

      project_ids.zip(values).to_h
    end

    def update_projects(project_ids, last_seen)
      Project.where(id: project_ids).find_each do |project|
        # rubocop:disable Rails/SkipsModelValidations
        project.update_column(:last_seen_at, Time.iso8601(last_seen[project.id]))
        # rubocop:enable Rails/SkipsModelValidations
      end
    end

    def persist_last_seen_db(project_ids, last_seen)
      KILLSWITCH_REDIS.pipelined do |pipe|
        project_ids.each do |id|
          pipe.set(last_seen_db_key(id), last_seen[id])
          pipe.expire(last_seen_db_key(id), LAST_SEEN_DB_TTL)
        end
      end
    end

    def last_seen_db_key(project_id)
      "analytics:last_seen_db:#{project_id}"
    end

    def tracker
      Analytics::ProjectActivityTracker
    end
  end
end
