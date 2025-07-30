class DeviseMailer < Devise::Mailer
  # Layout
  layout 'mailer'

  # Defaults
  default from: Rails.application.config_for(:settings)[:mailer_from]

  # Helpers
  helper MailerHelper
end
