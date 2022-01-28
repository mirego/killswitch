class Membership < ActiveRecord::Base
  # Camaraderie
  acts_as_membership
  # NOTE: This association is defined by the `acts_as_membership` method above.
  # However, we need to redefine it because we add `counter_cache`.
  belongs_to :organization, class_name: Camaraderie.organization_class, inverse_of: :memberships, counter_cache: true

  # Callbacks
  after_initialize { build_user if new_record? && user.blank? }
  before_validation :prepare_user, on: :create
  after_validation :restore_user, on: :create, if: lambda { errors.any? }

  # Scopes
  scope(:oldest, -> { order(created_at: :asc) })

protected

  # If we're trying to save a  membership with a user that already
  # exists we just use the existing user
  def prepare_user
    if existing_user = User.find_by(email: user.email)
      self.user_id = existing_user.id
    else
      # Assign a temporary password so the user can be valid
      user.password ||= SecureRandom.hex(20)
    end
  end

  # If the membership is not valid, we revert the user back to
  # a non-persisted copy so nested forms will not break
  def restore_user
    self.user = user.dup
  end
end
