class Project < ApplicationRecord
  # Associations
  belongs_to :application
  has_many :behaviors, -> { ascendingly }, dependent: :destroy, inverse_of: :project

  # Validations
  validates :name, presence: true, uniqueness: { scope: [:application_id, :deleted_at] }

  # Concerns
  include Keyable

  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :application

  # PaperTrail
  has_paper_trail

  # Scopes
  scope(:ascendingly, -> { order(name: :asc) })
end
