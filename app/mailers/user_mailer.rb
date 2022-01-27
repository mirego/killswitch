class UserMailer < ActionMailer::Base
  # Layout
  layout 'mailer'

  # Defaults
  default from: Rails.application.secrets.mailer_from

  # Helpers
  helper MailerHelper

  def welcome_email(user_id, token)
    @user = User.find(user_id)
    @token = token
    mail to: @user.email, subject: t('.subject')
  end
end
