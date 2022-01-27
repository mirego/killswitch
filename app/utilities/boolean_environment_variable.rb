class BooleanEnvironmentVariable
  def initialize(value)
    @value = value
  end

  def as_bool
    ![nil, '', '0', 'false'].include?(@value.try(:downcase))
  end
end
