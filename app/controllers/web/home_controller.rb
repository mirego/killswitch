class Web::HomeController < Web::ApplicationController
  skip_before_action :authenticate_user!

  def show
    return if current_user.blank?

    organization = current_user.organizations.first
    return if organization.blank?

    redirect_to web_organization_applications_path(organization_id: organization)
  end
end
