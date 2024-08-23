# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      {
        user: {
          email: 'user@example.com',
          password: 'password123',
          password_confirmation: 'password123' # Ensure password confirmation is included
        }
      }
    end

    context 'when the request is valid' do
      it 'creates a user and returns a 201 response' do
        post '/api/v1/users', params: valid_attributes
        expect(response).to have_http_status(201)
        expect(json['message']).to eq('User created successfully')
        expect(json).to have_key('api_key') # Ensure api_key is returned
      end
    end

    context 'when the request is invalid' do
      it 'returns a 422 response for missing password' do
        post '/api/v1/users', params: { user: { email: 'user@example.com' } } # Missing password
        expect(response).to have_http_status(422)
        expect(json['errors']).to include("Password can't be blank")
      end

      it 'returns a 422 response for mismatched password confirmation' do
        post '/api/v1/users', params: {
          user: {
            email: 'user@example.com',
            password: 'password123',
            password_confirmation: 'different_password' # Mismatched password confirmation
          }
        }
        expect(response).to have_http_status(422)
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe 'POST /api/v1/users/show_api_key' do
    let!(:user) do
      create(:user, email: 'user@example.com', password: 'password123', password_confirmation: 'password123')
    end

    context 'when the credentials are valid' do
      before { post '/api/v1/users/show_api_key', params: { email: user.email, password: 'password123' } }

      it 'returns the API key' do
        expect(response).to have_http_status(200)
        expect(json).to have_key('api_key')
        expect(json['api_key']).to eq(user.api_key)
      end
    end

    context 'when the credentials are invalid' do
      before { post '/api/v1/users/show_api_key', params: { email: user.email, password: 'wrong_password' } }

      it 'returns a 401 response' do
        expect(response).to have_http_status(401)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'POST /api/v1/users/regenerate_api_key' do
    let!(:user) do
      create(:user, email: 'user@example.com', password: 'password123', password_confirmation: 'password123')
    end

    context 'when the credentials are valid' do
      before { post '/api/v1/users/regenerate_api_key', params: { email: user.email, password: 'password123' } }

      it 'regenerates the API key and returns a 200 response' do
        expect(response).to have_http_status(200)
        expect(json).to have_key('api_key')
        expect(json['message']).to eq('API key regenerated successfully')
        expect(json['api_key']).not_to eq(user.api_key) # Ensure API key has changed
      end
    end

    context 'when the credentials are invalid' do
      before { post '/api/v1/users/regenerate_api_key', params: { email: user.email, password: 'wrong_password' } }

      it 'returns a 401 response' do
        expect(response).to have_http_status(401)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
