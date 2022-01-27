module Keyable
  extend ActiveSupport::Concern
  KEY_LENGTH = 32

  included do
    before_validation :generate_key, if: lambda { key.blank? }
    validates :key, presence: true, length: { is: KEY_LENGTH * 2 }
  end

  def generate_key
    self.key = SecureRandom.hex(KEY_LENGTH)
  end
end
