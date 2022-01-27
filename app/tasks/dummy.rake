namespace :dummy do
  task all: :environment  do
    # Mirego
    mirego = Organization.where(name: 'Mirego', super_admin: true).first_or_create

    # Rémi
    remi = User.where(name: 'Rémi Prévost', email: 'rprevost@mirego.com').first_or_create(password: 'test1234')
    mirego.admins.create(user: remi)

    # Gametime-API
    app1 = mirego.applications.where(name: 'Gametime-API').first_or_create
    app1.projects.where(name: 'Development').create
    app1.projects.where(name: 'Staging').create
    app1.projects.where(name: 'Production').create

    # Paperless-Admin
    app2 = mirego.applications.where(name: 'Paperless-Admin').first_or_create
    app2.projects.where(name: 'Development').create
    app2.projects.where(name: 'Staging').create
    app2.projects.where(name: 'Production').create
  end
end
