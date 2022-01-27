class Web::OrganizationsController < Web::ApplicationController
  before_action :fetch_organizations, only: [:index]
  before_action :fetch_organization, only: [:edit, :update, :destroy]

  # GET /organizations
  def index
    authorize! :manage, Organization
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/:id/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to web_organizations_path, notice: t('.notice')
    else
      render :new
    end
  end

  # PUT /organizations/:id
  # PATCH /organizations/:id
  def update
    if @organization.update(organization_params)
      redirect_to web_organizations_path, notice: t('.notice')
    else
      render :edit
    end
  end

  # DELETE /organizations/:id
  def destroy
    if @organization.destroy
      redirect_to web_organizations_path, notice: t('.notice')
    else
      redirect_to web_organizations_path, alert: t('.alert')
    end
  end

protected

  def fetch_organizations
    @organizations = Organization.ascendingly
  end

  def fetch_organization
    @organization = Organization.friendly.find(params[:id])
  end

  def organization_params
    permitted_parameters = [:name]
    params.require(:organization).permit(*permitted_parameters)
  end
end
