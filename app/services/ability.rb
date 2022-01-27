class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new

    if @user.super_powers?
      # We can do everything!
      can :manage, :all

      # Prevent from destroying super-admin organizations
      cannot :destroy, Organization do |organization|
        organization.super_admin?
      end
    else
      organization_permissions
    end

    # Prevent users from removing themselves from organizations
    cannot(:destroy, Membership) do |membership|
      membership.user == user
    end
  end

protected

  def organization_permissions
    can(:access, Organization) { |organization| @user.allowed_in?(organization) }
  end
end
