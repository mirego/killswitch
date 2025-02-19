Sprockets::ES6.configure do |config|
  config.moduleIds = true
  config.modules = 'amd'
  config.keepModuleIdExtensions = false
  config.loose = %w(es6.classes)
end
