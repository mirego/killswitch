class API::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session
end
