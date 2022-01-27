class Web::ErrorsController < Web::ApplicationController
  include Gaffe::Errors

  # Layout
  layout 'application'

  # Allow all users to view error pages
  skip_before_action :authenticate_user!

  def show
    render "web/errors/#{@rescue_response}", status: @status_code
  rescue ActionView::MissingTemplate
    render 'web/errors/internal_server_error', status: @status_code
  end
end
