class BehaviorDispatcher
  attr_reader :matching_behavior

  class MissingParameter < StandardError
  end

  def dispatch!(request)
    @request = request

    fetch_version
    fetch_key
    fetch_project
    fetch_language

    @matching_behavior = @project.behaviors.find { |b| matches?(b) }
    @matching_behavior ||= Behavior::DefaultBehavior
  end

protected

  def fetch_version
    @version = Versionomy.parse(@request.params[:version])
  rescue
    raise MissingParameter, 'Missing or invalid “version” parameter'
  end

  def fetch_key
    @key = @request.params[:key]
    raise MissingParameter, 'Missing or invalid “key” parameter' unless @key.present?
  end

  def fetch_project
    @project = Project.where(key: @key).includes(:behaviors).first!
  end

  def fetch_language
    available_languages = @project.behaviors.pluck(:language).compact.uniq
    return unless available_languages.any?

    if params[:http_accept_language].present?
      language_matcher = Rack::Accept::Language.new(params[:http_accept_language])
    else
      language_matcher = @request.env['rack-accept.request'].language
    end

    language_matcher.first_level_match = true
    @language = language_matcher.best_of(available_languages)
  end

  # Return true only if all our conditions are true
  def matches?(behavior)
    conditions = [
      version_matches?(behavior),
      language_matches?(behavior),
      time_matches?(behavior)
    ]

    !conditions.include?(false)
  end

  # Return true if our version matches
  def version_matches?(behavior)
    # Eg. '1.5.0'.send(:<=, '1.4.0') # => false
    @version.send(behavior.version_operator_method, behavior.parsed_version)
  end

  # Return true if our time matches
  def time_matches?(behavior)
    return true if behavior.time.blank?

    Time.zone.now.utc.public_send(behavior.time_operator_method, behavior.time)
  end

  # Return true if our language matches
  def language_matches?(behavior)
    behavior.language.nil? || @language == behavior.language
  end

  def params
    @params ||= @request.env['action_dispatch.request.parameters'].with_indifferent_access
  end
end
