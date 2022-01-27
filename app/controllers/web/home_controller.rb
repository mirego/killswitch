class Web::HomeController < Web::ApplicationController
  skip_before_action :authenticate_user!

  def show
    return unless current_user.present?

    organization = current_user.organizations.first
    redirect_to web_organization_applications_path(organization_id: organization)
  end
end
