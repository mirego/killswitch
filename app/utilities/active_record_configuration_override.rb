class ActiveRecordConfigurationOverride
  def self.override!
    # Reset ActiveRecord logger
    ActiveRecord::Base.logger = Rails.logger
  end
end
