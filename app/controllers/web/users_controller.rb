class Web::UsersController < Web::ApplicationController
  before_action :fetch_user, only: [:show, :update, :edit, :destroy]

  # GET /users/:id/edit
  def edit; end

  # PUT /users/:id
  # PATCH /users/:id
  def update
    if @user.update(user_params)
      redirect_to root_path, notice: t('.notice')
    else
      render :edit
    end
  end

protected

  def fetch_user
    @user = User.friendly.find(params[:id])
  end

private

  def user_params
    permitted_parameters = [:name, :email, :password]
    params.require(:user).permit(*permitted_parameters).delete_if { |_, value| value.empty? }
  end
end
