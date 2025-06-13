source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"
gem 'active_model_serializers', '~> 0.10.15'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'dry-transaction', '~> 0.16.0'
gem 'dry-monads', '~> 1.8', '>= 1.8.3'
gem 'dry-validation', '~> 1.11', '>= 1.11.1'
gem 'dry-container', '~> 0.11.0'
gem 'dry-auto_inject', '~> 1.1'
gem 'dry-matcher', '~> 1.0'
gem 'dry-system', '~> 1.2', '>= 1.2.2'
gem 'graphql'
gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'doorkeeper', '~> 5.8', '>= 5.8.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'graphiql-rails', github: "rmosolgo/graphiql-rails", group: :development
  gem 'pry-rails'
end
