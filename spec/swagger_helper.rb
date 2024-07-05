require 'rails_helper'
require 'rswag/swagger'
require 'rswag/api'
require 'rswag/ui'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'
  config.openapi_specs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
        description: 'API V1 description'
      },
      paths: {}
    }
  }
end

Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.join('swagger').to_s
end

Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/v1/swagger.json', '/api-docs/v1/swagger.json'
end

Rswag::Specs::SwaggerRoot.prepend(Module.new do
  def build_path
    super
    add_sign_up_path
    add_sign_in_path
    # Add other paths here as needed
  end

  def add_sign_up_path
    swagger_path '/api/v1/sign_up' do
      operation :post do
        key :summary, 'Create a new user'
        key :tags, ['Authentication']
        key :description, 'Registers a new user'
        parameter do
          key :name, :user
          key :in, :body
          key :required, true
          schema do
            key :'$ref', :UserInput
          end
        end
        response 200 do
          key :description, 'User created successfully'
        end
      end
    end
  end

  def add_sign_in_path
    swagger_path '/api/v1/sign_in' do
      operation :post do
        key :summary, 'User sign in'
        key :tags, ['Authentication']
        key :description, 'Signs in a user'
        parameter do
          key :name, :user
          key :in, :body
          key :required, true
          schema do
            key :'$ref', :UserCredentials
          end
        end
        response 200 do
          key :description, 'User signed in successfully'
        end
      end
    end
  end
end)
