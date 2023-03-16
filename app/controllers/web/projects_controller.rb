class Web::ProjectsController < Web::ApplicationController
  before_action :fetch_organization
  before_action :fetch_application
  before_action :fetch_project, only: [:show, :update, :edit, :destroy]

  # GET /applications/:application_id/projects/:id
  def show; end

  # GET /applications/:application_id/projects/new
  def new
    @project = @application.projects.build
  end

  # GET /applications/:application_id/projects/:id/edit
  def edit; end

  # POST /applications/:application_id/projects
  def create
    @project = @application.projects.build(project_params)

    if @project.save
      redirect_to web_organization_application_path(id: @application), notice: t('.notice')
    else
      render :new
    end
  end

  # PUT /applications/:application_id/projects/:id
  # PATH /applications/:application_id/projects/:id
  def update
    if @project.update(project_params)
      redirect_to web_organization_application_project_path, notice: t('.notice')
    else
      render :edit
    end
  end

  # GET /applications/:application_id/projects/:id
  def destroy
    if @project.destroy
      redirect_to web_organization_application_path(id: @application), notice: t('.notice')
    else
      redirect_to web_organization_application_path(id: @application), alert: t('.alert')
    end
  end

protected

  def fetch_organization
    @organization = Organization.friendly.find(params[:organization_id])

    authorize! :access, @organization
  end

  def fetch_application
    @application = @organization.applications.friendly.find(params[:application_id])
  end

  def fetch_project
    @project = @application.projects.friendly.find(params[:id])
  end

private

  def project_params
    permitted_parameters = [:name]
    params.require(:project).permit(*permitted_parameters)
  end
end
