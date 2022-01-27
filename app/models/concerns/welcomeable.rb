module Welcomeable
  extend ActiveSupport::Concern

  included do
    # Callbacks
    after_commit :send_welcome_email!, on: :create, if: lambda { !skip_welcome_email && reset_password_token.blank? }

    # Accessors
    attr_accessor :skip_welcome_email
  end

  def send_welcome_email!
    UserMailer.welcome_email(id, set_reset_password_token).deliver_now
  end
end
