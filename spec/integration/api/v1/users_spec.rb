# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users' do
    post('create user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object, # This should be an object
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: ['user'] # Ensure that the user object is required
      }

      response(201, 'created') do
        let(:user) { { user: { email: 'user@example.com', password: 'password', password_confirmation: 'password' } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:user) { { user: { email: 'user@example.com' } } } # This must match the schema structure
        run_test!
      end
    end
  end

  path '/api/v1/users/show_api_key' do
    get('show API key') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response(200, 'successful') do
        let(:credentials) { { email: 'user@example.com', password: 'password' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:credentials) { { email: 'user@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/regenerate_api_key' do
    post('regenerate API key') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response(200, 'successful') do
        let(:credentials) { { email: 'user@example.com', password: 'password' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:credentials) { { email: 'user@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end
end
