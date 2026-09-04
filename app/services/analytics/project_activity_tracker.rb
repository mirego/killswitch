module Analytics
  # Tracks project API hits in Redis. Runs on the hot path of GET /killswitch,
  # so it must be fast (single pipelined round-trip) and must never raise:
  # a Redis failure should never break the API response.
  class ProjectActivityTracker
    COUNTER_TTL = 48.hours.to_i
    LAST_SEEN_TTL = 90.days.to_i

    class << self
      def track(project_id, at: Time.zone.now)
        return unless enabled?

        date = at.utc.to_date.to_s

        KILLSWITCH_REDIS.pipelined do |pipe|
          pipe.incr(counter_key(project_id, date))
          pipe.expire(counter_key(project_id, date), COUNTER_TTL)
          pipe.sadd(active_projects_key(date), project_id)
          pipe.expire(active_projects_key(date), COUNTER_TTL)
          pipe.sadd(active_dates_key, date)
          pipe.set(last_seen_key(project_id), at.utc.iso8601)
          pipe.expire(last_seen_key(project_id), LAST_SEEN_TTL)
        end
      rescue Redis::BaseError => e
        Rails.logger.warn("Analytics tracking failed: #{e.message}")
        Sentry.capture_exception(e) if defined?(Sentry)
        nil
      end

      def enabled?
        ENV['ANALYTICS_ENABLED'] == 'true'
      end

      def counter_key(project_id, date)
        "analytics:requests:#{project_id}:#{date}"
      end

      def active_projects_key(date)
        "analytics:active_projects:#{date}"
      end

      def active_dates_key
        'analytics:active_dates'
      end

      def last_seen_key(project_id)
        "analytics:last_seen:#{project_id}"
      end
    end
  end
end
