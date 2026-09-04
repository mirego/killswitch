namespace :analytics do
  desc 'Flush Redis activity counters into PostgreSQL'
  task flush: :environment do
    Analytics::FlushRedisToDatabase.call
  end
end
