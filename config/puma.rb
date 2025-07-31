# Port
port ENV.fetch('PORT', 3000)

# Environment
environment ENV.fetch('RACK_ENV')

# Workers count
workers ENV.fetch('PUMA_WORKERS', 0)

# Threads count per worker
min_threads = ENV.fetch('PUMA_MIN_THREADS', 0)
max_threads = ENV.fetch('PUMA_MAX_THREADS', 5)
threads min_threads, max_threads

# Preload the app
preload_app!
