if Rails.application.secrets.sentry_dsn.present?
  Sentry.init do |config|
    config.dsn = Rails.application.secrets.sentry_dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    config.excluded_exceptions += %w(
      ActionController::RoutingError
      ActiveRecord::RecordNotFound
      CanCan::AccessDenied
      ActionController::InvalidAuthenticityToken
      BehaviorDispatcher::MissingParameter
    )
  end
end
