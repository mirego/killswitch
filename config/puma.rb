# Environment
environment ENV['RACK_ENV']

# Workers count
workers ENV['PUMA_WORKERS'] || 1

# Threads count per worker
min_threads = ENV['PUMA_MIN_THREADS'] || 0
max_threads = ENV['PUMA_MAX_THREADS'] || 5
threads min_threads, max_threads

# Preload the app
preload_app!

# Run code when a worker is spawned
on_worker_boot do
  # Set a global logger
  Rails.logger = ActiveSupport::Logger.new(STDOUT)

  # Set ActiveRecord config
  ActiveSupport.on_load(:active_record) do
    ActiveRecordConfigurationOverride.override!
  end

  # Set ActionController config
  ActiveSupport.on_load(:action_controller) do
    ActionController::Base.logger = Rails.logger
  end

  # Set ActionView config
  ActiveSupport.on_load(:action_view) do
    ActionView::Base.logger = Rails.logger
  end
end
