class ApplicationMailer < ActionMailer::Base
  # Layout
  layout 'mailer'

  # Defaults
  default from: Rails.application.secrets.mailer_from

  # Helpers
  helper MailerHelper
end
