class Web::ApplicationsController < Web::ApplicationController
  before_action :fetch_organization
  before_action :fetch_application, only: [:show, :update, :edit, :destroy]

  # GET /
  # GET /applications
  def index
    @applications = @organization.applications.includes(:projects)
  end

  # GET /applications/:id
  def show; end

  # GET /applications/new
  def new
    @application = @organization.applications.build
  end

  # GET /applications/:id/edit
  def edit; end

  # POST /applications
  def create
    @application = @organization.applications.build(application_params)

    if @application.save
      redirect_to web_organization_application_path(id: @application), notice: t('.notice')
    else
      render :new
    end
  end

  # PUT /applications
  # PATCH /applications/:id
  def update
    if @application.update(application_params)
      redirect_to web_organization_application_path, notice: t('.notice')
    else
      render :edit
    end
  end

  # DELETE /applications/:id
  def destroy
    if @application.destroy
      redirect_to web_organization_applications_path, notice: t('.notice')
    else
      redirect_to web_organization_applications_path, alert: t('.alert')
    end
  end

protected

  def fetch_organization
    @organization = Organization.friendly.find(params[:organization_id])

    authorize! :access, @organization
  end

  def fetch_application
    @application = @organization.applications.friendly.find(params[:id])
  end

private

  def application_params
    permitted_parameters = [:name]
    params.require(:application).permit(*permitted_parameters)
  end
end
