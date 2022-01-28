class Organization < ActiveRecord::Base
  # Associations
  has_many :applications, -> { ascendingly }, dependent: :destroy

  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Validations
  validates :name, presence: true

  # Camaraderie
  acts_as_organization

  # Scopes
  scope(:ascendingly, -> { order(Arel.sql('lower(name) asc')) })
end
