class EmailValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_email)
    options.reverse_merge!(regex: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
    super
  end

  def validate_each(record, attribute, value)
    return if value =~ options.fetch(:regex)
    record.errors.add(attribute, options.fetch(:message), value: value)
  end
end
