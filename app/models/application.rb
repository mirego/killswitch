class Application < ActiveRecord::Base
  # Associations
  has_many :projects, -> { ascendingly }, dependent: :destroy
  belongs_to :organization, counter_cache: true

  # Validations
  validates :name, presence: true, uniqueness: { scope: [:deleted_at] }

  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: :slugged

  # PaperTrail
  has_paper_trail

  # Scopes
  scope :ascendingly, -> { order(name: :asc) }
end
