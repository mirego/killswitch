class BooleanEnvironmentVariable
  def initialize(value)
    @value = value
  end

  def as_bool
    [nil, '', '0', 'false'].exclude?(@value.try(:downcase))
  end
end
