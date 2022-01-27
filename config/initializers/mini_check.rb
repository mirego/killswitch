HealthChecks = MiniCheck::RackApp.new(path: '/health')
HealthChecks.register('database') { ActiveRecord::Base.connection.active? }
