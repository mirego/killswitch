namespace :sample_data do
  task create: :environment do
    Rails.logger = Logger.new(STDOUT)

    # Example organization
    example_organization = Organization.where(name: 'Example inc.', super_admin: true).first_or_create

    # Admin user
    email = ENV["KILLSWITCH_SAMPLE_DATA_EMAIL"] or raise "KILLSWITCH_SAMPLE_DATA_EMAIL is not set"
    password = ENV["KILLSWITCH_SAMPLE_DATA_PASSWORD"] or raise "KILLSWITCH_SAMPLE_DATA_PASSWORD is not set"
    Rails.logger.info "Admin email: #{email}"
    Rails.logger.info "Admin password: #{password}"
    admin_user = User.where(name: email, email: email).first_or_create(password: password)
    example_organization.admins.create(user: admin_user)

    # First application
    app1 = example_organization.applications.where(name: 'First project').first_or_create
    app1.projects.where(name: 'Development').create
    app1.projects.where(name: 'Staging').create
    app1.projects.where(name: 'Production').create

    # Second application
    app2 = example_organization.applications.where(name: 'Second application').first_or_create
    app2.projects.where(name: 'Development').create
    app2.projects.where(name: 'Staging').create
    app2.projects.where(name: 'Production').create
  end
end
