Camaraderie.configure do |config|
  # The different types of memberships
  config.membership_types = %w(admin)

  # The class name of the organization model
  config.organization_class = 'Organization'

  # The class name of the user model
  config.user_class = 'User'
end
