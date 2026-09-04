# Shared Redis connection used by the analytics pipeline.
# The redis gem (>= 5) is thread-safe, so a single connection can be
# shared across Puma threads.
KILLSWITCH_REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
