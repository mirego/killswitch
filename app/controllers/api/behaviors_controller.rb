class API::BehaviorsController < API::ApplicationController
  # Constants
  VARY_HEADER = 'Accept-Language'.freeze

  # GET /killswitch
  def show
    dispatcher = BehaviorDispatcher.new
    dispatcher.dispatch!(request)

    headers['Vary'] = VARY_HEADER
    render json: dispatcher.matching_behavior
  end
end
