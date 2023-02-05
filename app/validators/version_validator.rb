class VersionValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_version)
    super
  end

  def validate_each(record, attribute, value)
    if value.blank?
      add_error(record, attribute, value)
    else
      begin
        Versionomy.parse(value)
      rescue Versionomy::Errors::ParseError
        add_error(record, attribute, value)
      end
    end
  end

protected

  def add_error(record, attribute, value)
    record.errors.add(attribute, options.fetch(:message), value:)
  end
end
