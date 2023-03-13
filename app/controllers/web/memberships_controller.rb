class Web::MembershipsController < Web::ApplicationController
  before_action :fetch_organization
  before_action :fetch_membership, only: [:update, :edit, :destroy]

  # GET /memberships
  def index
    @memberships = @organization.memberships.oldest
  end

  # GET /memberships/new
  def new
    @membership = @organization.admins.new(user: User.new)
  end

  # GET /memberships/:id/edit
  def edit; end

  # POST /memberships
  def create
    @membership = @organization.memberships.new(membership_params(context: :create))

    if @membership.save
      redirect_to web_organization_memberships_path, notice: t('.notice')
    else
      render :new
    end
  end

  # PUT /memberships/:id
  # PATCH /memberships/:id
  def update
    if @membership.update(membership_params(context: :update))
      redirect_to web_organization_memberships_path, notice: t('.notice')
    else
      render :edit
    end
  end

  # DELETE /memberships/:id
  def destroy
    if @membership.destroy
      redirect_to web_organization_memberships_path, notice: t('.notice')
    else
      redirect_to web_organization_memberships_path, alert: t('.alert')
    end
  end

protected

  def fetch_organization
    @organization = Organization.friendly.find(params[:organization_id])

    authorize! :access, @organization
  end

  def fetch_membership
    @membership = @organization.memberships.find(params[:id])
  end

private

  def create_membership_params
    [{ user_attributes: [:name, :email] }, :membership_type]
  end

  def update_membership_params
    [:membership_type]
  end

  def membership_params(context: :create)
    permitted_parameters = send(:"#{context}_membership_params")
    params.require(:membership).permit(*permitted_parameters).delete_if { |_, value| value.empty? }
  end
end
