# spec/rails_helper.rb

# Load spec_helper
require 'spec_helper'

# Set the Rails environment to 'test'
ENV['RAILS_ENV'] ||= 'test'

# Load Rails environment
require File.expand_path('../config/environment', __dir__)

# Prevent loading in production mode
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Require RSpec and RSpec Rails
require 'rspec/rails'

# Require RSwag
require 'rswag/specs'
require 'rswag/api'

# Require FactoryBot
require 'factory_bot_rails'

# Require Shoulda Matchers
require 'shoulda-matchers'

# Configure RSpec
RSpec.configure do |config|
  # Set the directory for OpenAPI/Swagger specifications
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define Swagger documentation details
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API',
        version: 'v1',
      },
      paths: {},
    }
  }



  # Use transactional fixtures for faster tests
  config.use_transactional_fixtures = true

  # Infer the spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtraces
  config.filter_rails_from_backtrace!

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Configure Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
