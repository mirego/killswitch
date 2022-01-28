class Web::ApplicationController < ::ApplicationController
  # CSRF Protection
  protect_from_forgery with: :exception

  # Users must be authenticated everywhere
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  # Expose some methods to views
  helper_method :current_organization

protected

  def current_organization
    return nil if params[:organization_id].blank?

    @current_organization ||= begin
      Organization.friendly.find(params[:organization_id]).tap do |organization|
        authorize! :access, organization
      end
    end
  end

  def after_sign_in_path_for(resource)
    safe_redirect_path(stored_location_for(resource))
  end

  def after_sign_out_path_for(*)
    safe_redirect_path(request.referer)
  end

  # Returns the path only if it responds to GET requests. Otherwise returns root.
  def safe_redirect_path(path)
    return root_path if path.blank?

    Rails.application.routes.recognize_path(path, method: :get)
  rescue ActionController::RoutingError
    root_path
  end
end
