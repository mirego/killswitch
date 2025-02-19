# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Killswitch::Application.load_tasks

# Load tasks in app/tasks
Rails.root.glob('app/tasks/**/*.rake').each { |f| load f }
