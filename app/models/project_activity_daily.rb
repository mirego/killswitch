class ProjectActivityDaily < ApplicationRecord
  # Associations
  belongs_to :project

  # Validations
  validates :date, presence: true, uniqueness: { scope: :project_id }
  validates :request_count, numericality: { greater_than_or_equal_to: 0 }
end
