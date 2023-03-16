class BehaviorPresenter < Bourgeois::Presenter
  # Structs
  Dropdown = Struct.new(:id, :label)

  def self.version_operators
    @_version_operators ||= Behavior::VERSION_OPERATORS.keys.map do |operator|
      Dropdown.new(id: operator, label: version_operator_label(operator))
    end
  end

  def self.time_operators
    @_time_operators ||= Behavior::TIME_OPERATORS.keys.map do |operator|
      Dropdown.new(id: operator, label: time_operator_label(operator))
    end
  end

  def self.languages
    @_languages ||= Behavior::LANGUAGES.map do |language|
      Dropdown.new(id: language, label: language_label(language))
    end
  end

  def human_language
    BehaviorPresenter.language_label(language)
  end

  def human_version_operator
    BehaviorPresenter.version_operator_label(version_operator)
  end

  def human_time_operator
    BehaviorPresenter.time_operator_label(time_operator)
  end

  def human_version
    "#{human_version_operator} #{version_number}"
  end

  def human_time
    return I18n.t('activerecord.attributes.behavior.empty_time') if time.nil?

    "#{human_time_operator} #{time}"
  end

  def pretty_data
    JSON.pretty_generate(data)
  end

  def action
    data['action']
  end

  def self.language_label(language)
    I18n.t("activerecord.attributes.behavior.languages.#{language.presence || 'any'}")
  end

  def self.version_operator_label(operator)
    I18n.t("activerecord.attributes.behavior.version_operators.#{operator}")
  end

  def self.time_operator_label(operator)
    I18n.t("activerecord.attributes.behavior.time_operators.#{operator}")
  end
end
