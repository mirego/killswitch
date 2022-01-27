source 'https://rubygems.org'
ruby '2.6.7'

# Use Rails, you know, for the framework
gem 'rails', '~> 6.1.4.2'
gem 'bootsnap'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use puma as the web server
gem 'puma'

# Make sure our .env file is sourced everywhere
gem 'dotenv-rails'

# Use Bourgeois to get presenters
gem 'bourgeois'

# Use FriendlyId to get prettier URLs
gem 'friendly_id', git: 'https://github.com/norman/friendly_id.git', ref: '35ce3de1c65682004cad00fe90f546137499cd64'

# Use Sass
gem 'sass-rails', '~> 5.1'

# Use Turbolinks for faster pages!
gem 'turbolinks', '~> 5.0'
gem 'jquery-turbolinks'

# Use Uglifier to make the JavaScript uglier than it already is
gem 'uglifier'

# Use Versionomy to parse and compare version numbers
gem 'versionomy'

# Use ranked-model to sort records
gem 'ranked-model'

# Use Rack::Accept to negociate content based on HTTP headers
gem 'rack-accept', require: 'rack/accept'

# Use Rack::CanonicalHost to ensure a single valid hostname
gem 'rack-canonical-host', '1.0.0'

# Use ActiveRecord::JSONValidator to validate JSON columns with a schema
gem 'activerecord_json_validator', '1.3.0'

# Use Devise to manage users
gem 'devise', '~> 4.7'

# Use Sentry to track errors
gem 'sentry-ruby'
gem 'sentry-rails'

# Use gaffe to display errors
gem 'gaffe', '1.2.0'

# Use Camaraderie to divide users into organizations
gem 'camaraderie'

# Use cancancan to manage permissions
gem 'cancancan', '~> 1.15'

# Use PaperTrail to track changes to models
gem 'paper_trail', '~> 11.1'

# Use Rack:SSL to force HTTPS on non-API requests
gem 'rack-ssl', require: 'rack/ssl'

# Use Autoprefixer Rails to avoid writing CSS vendor prefixes
gem 'autoprefixer-rails', '6.4.0.1'

# Use sprockets-es6 to use ES6 scripts
gem 'sprockets-es6'

# Use Rack::Cors to allow cross-domain requests
gem 'rack-cors', require: 'rack/cors'

# Use MiniCheck to provide a healthcheck endpoint
gem 'mini_check'

group :development, :test do
  # Test with RSpec
  gem 'rspec-rails', '~> 5.0'

  # Test with FactoryGirl
  gem 'factory_girl_rails'

  # Flush data with DatabaseCleaner
  gem 'database_cleaner-active_record'

  # Use FFaker for (faster) random data
  gem 'ffaker'

  # Use Rubocop to ensure Ruby style compliance
  gem 'rubocop'
  gem 'parser', '2.6.5.0'
end

group :development do
  # Use Spring for speed
  gem 'spring'

  # Use spring-commands-rspec to use RSpec with Spring
  gem 'spring-commands-rspec'
end

group :production do
  # Use Rails 12 Factor to run smoothly on Heroku
  gem 'rails_12factor'
end
