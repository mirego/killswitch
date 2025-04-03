class User < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, presence: true, email: true, uniqueness: { scope: [:deleted_at] }
  validates :password, length: { within: 8..128, allow_blank: true }, presence: { if: :password_required? }

  # Devise
  devise :database_authenticatable, :rememberable, :trackable, :recoverable, :password_archivable, :session_limitable

  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Camaraderie
  acts_as_user

  # PaperTrail
  has_paper_trail

  # Concerns
  include Welcomeable

  def super_powers?
    organizations.exists?(super_admin: true)
  end

  def allowed_in?(organization)
    allowed_organizations.include?(organization)
  end

  def allowed_organizations
    @allowed_organizations ||= begin
      # Include explicit memberships
      organization_ids = memberships.includes(:organization).pluck(:organization_id)

      # Include all organizations if we’re member of an admin organization
      organization_ids += Organization.pluck(:id) if super_powers?

      # Get all organizations and order them by name
      Organization.where(id: organization_ids.uniq).ascendingly
    end
  end

protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
