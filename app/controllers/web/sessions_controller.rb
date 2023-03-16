class Web::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters

protected

  # White-list parameters for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :remember_me])
  end
end
