class API::ErrorsController < API::ApplicationController
  include Gaffe::Errors

  def show
    render json: { error: @rescue_response }, status: @status_code
  end
end
