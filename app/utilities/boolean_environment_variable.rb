class BooleanEnvironmentVariable
  def initialize(value)
    @value = value
  end

  # rubocop:disable Naming/PredicateMethod
  def as_bool
    [nil, '', '0', 'false'].exclude?(@value.try(:downcase))
  end
  # rubocop:enable Naming/PredicateMethod
end
