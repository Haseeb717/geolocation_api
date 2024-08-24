require 'swagger_helper'

RSpec.describe 'Geolocations API', type: :request do
  let(:api_key) { 'valid_api_key' } # Replace with a valid API key for the test user

  path '/api/v1/geolocations' do
    get('list geolocations') do
      tags 'Geolocations'
      produces 'application/json'
      security [Bearer: []]

      response(200, 'successful') do
        run_test!
      end
    end

    post('create geolocation') do
      tags 'Geolocations'
      consumes 'application/json'
      parameter name: :geolocation, in: :body, schema: {
        type: :object,
        properties: {
          provider: { type: :string },
          ip_address: { type: :string, nullable: true },
          url: { type: :string, nullable: true }
        },
        required: ['provider']
      }
      security [Bearer: []]

      response(201, 'created') do
        let(:geolocation) { { provider: 'ipstack', ip_address: '95.91.246.12' } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:geolocation) { { provider: 'invalid_provider' } }
        run_test!
      end
    end
  end

  path '/api/v1/geolocations/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID of the geolocation'

    get('show geolocation') do
      tags 'Geolocations'
      produces 'application/json'
      security [Bearer: []]

      response(200, 'successful') do
        let(:id) { Geolocation.create!(provider: 'ipstack', ip_address: '95.91.246.12').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete('delete geolocation') do
      tags 'Geolocations'
      produces 'application/json'
      security [Bearer: []]

      response(204, 'successful') do
        let(:id) { Geolocation.create!(provider: 'ipstack', ip_address: '95.91.246.12').id }
        run_test!
      end
    end
  end
end
