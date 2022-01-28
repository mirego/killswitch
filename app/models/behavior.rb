class Behavior < ActiveRecord::Base
  # Constants
  VERSION_OPERATORS = { 'lt' => :<, 'lte' => :<=, 'eq' => :==, 'gte' => :>=, 'gt' => :> }.freeze
  TIME_OPERATORS = { 'lt' => :<, 'gt' => :> }.freeze
  LANGUAGES = %w(fr en de es it pt).freeze
  DATA_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'behavior_data.jsonschema').to_s

  # Validations
  validates :project, presence: true
  validates :version_number, presence: true, version: true
  validates :version_operator, presence: true, inclusion: { in: VERSION_OPERATORS.keys }
  validates :time, presence: true, if: :time_operator?
  validates :time_operator, presence: true, inclusion: { in: TIME_OPERATORS.keys }, if: :time?
  validates :language, inclusion: { in: LANGUAGES }, allow_nil: true
  validates :data, presence: true, json: { schema: DATA_JSON_SCHEMA, message: ->(errors) { format_invalid_json_errors(errors) } }

  # Associations
  belongs_to :project
  has_one :application, through: :project

  # RankModel
  include RankedModel
  ranks :behavior_order, with_same: :project_id

  # PaperTrail
  has_paper_trail

  # Scopes
  scope(:ascendingly, -> { rank(:behavior_order) })

  def self.format_invalid_json_errors(errors)
    errors = errors.map { |error| error }.join(', ')
    I18n.t('activerecord.errors.messages.invalid_json', errors: errors)
  end

  # Make sure we set `language` to nil if we receive a blank value
  def language=(language)
    language.blank? ? super(nil) : super
  end

  # Return the "versionified" version
  def parsed_version
    Versionomy.parse(version_number)
  end

  # Return the Ruby method to use when comparing versions
  def version_operator_method
    VERSION_OPERATORS[version_operator]
  end

  # Return the Ruby method to use when comparing times
  def time_operator_method
    TIME_OPERATORS[time_operator]
  end

  # Return the `data` attribute when we serialize the behavior
  def as_json(*)
    data
  end

  # Return a class that acts like a default behavior
  class DefaultBehavior < ::Behavior
    def self.as_json(*)
      { action: 'ok' }
    end
  end
end
