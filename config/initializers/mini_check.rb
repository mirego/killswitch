HealthChecks = MiniCheck::RackApp.new(path: '/health')
HealthChecks.register('noop') { true }
HealthChecks.register('database') { ActiveRecord::Base.connection.active? }
