Gaffe.configure do |config|
  config.errors_controller = {
    %r{^/killswitch} => 'API::ErrorsController',
    %r{^/} => 'Web::ErrorsController'
  }
end

Gaffe.enable!
