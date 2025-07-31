class Web::BehaviorsController < Web::ApplicationController
  before_action :fetch_organization
  before_action :fetch_application
  before_action :fetch_project
  before_action :fetch_behavior, only: [:update, :edit, :destroy]

  # GET /applications/:application_id/projects/:project_id/behaviors/new
  def new
    @behavior = @project.behaviors.build
  end

  # GET /applications/:application_id/projects/:project_id/behaviors/:id
  def edit; end

  # POST /applications/:application_id/projects/:project_id/behaviors
  def create
    @behavior = @project.behaviors.build(behavior_params)

    if @behavior.save
      redirect_to web_organization_application_project_path(application_id: @application, id: @project), notice: t('.notice')
    else
      render :new
    end
  end

  # PUT /applications/:application_id/projects/:project_id/behaviors/:id
  # PATCH /applications/:application_id/projects/:project_id/behaviors/:id
  def update
    if @behavior.update(behavior_params)
      redirect_to web_organization_application_project_path(application_id: @application, id: @project), notice: t('.notice')
    else
      render :edit
    end
  end

  # DELETE /applications/:application_id/projects/:project_id/behaviors/:id
  def destroy
    if @behavior.destroy
      redirect_to web_organization_application_project_path(application_id: @application, id: @project), notice: t('.notice')
    else
      redirect_to web_organization_application_project_path(application_id: @application, id: @project), alert: t('.alert')
    end
  end

  # PUT /applications/:application_id/projects/:project_id/behaviors/order
  def order
    sorter = BehaviorSorter.new(@project)
    sorter.reorder!(params[:behaviors])

    head :ok
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
    @project = @application.projects.friendly.find(params[:project_id])
  end

  def fetch_behavior
    @behavior = @project.behaviors.find(params[:id])
  end

private

  def behavior_params
    permitted_parameters = [:version_number, :version_operator, :time, :time_operator, :language, :data]
    params.expect(behavior: [*permitted_parameters])
  end
end
