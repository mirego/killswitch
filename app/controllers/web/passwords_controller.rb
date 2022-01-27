class Web::PasswordsController < ::Devise::PasswordsController
protected

  # Where to redirect after users reset their password
  def after_resetting_password_path_for(*)
    root_path
  end
end
