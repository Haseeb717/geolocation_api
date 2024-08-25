# frozen_string_literal: true

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
          provider: { type: :string, nullable: true },
          ip_address: { type: :string, nullable: false },
          url: { type: :string, nullable: true }
        },
        required: ['ip_address']
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

  path '/api/v1/geolocations/{ip_address}' do
    get('show geolocation') do
      tags 'Geolocations'
      produces 'application/json'
      parameter name: 'ip_address', in: :path, type: :string, description: 'IP Address of the geolocation'
      security [Bearer: []]

      response(200, 'successful') do
        let(:ip_address) { '95.91.246.12' }
        run_test!
      end

      response(404, 'not found') do
        let(:ip_address) { 'invalid_ip_address' }
        run_test!
      end
    end

    put('update geolocation') do
      tags 'Geolocations'
      consumes 'application/json'
      parameter name: 'ip_address', in: :path, type: :string, description: 'IP Address of the geolocation'
      security [Bearer: []]

      response(200, 'successful') do
        let(:ip_address) { '95.91.246.12' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to be_truthy
        end
      end

      response(404, 'not found') do
        let(:ip_address) { 'invalid_ip_address' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Geolocation not found')
        end
      end

      response(422, 'unprocessable entity') do
        let(:ip_address) { '95.91.246.12' }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to be_present
        end
      end

      response(500, 'geolocation error') do
        let(:ip_address) { '95.91.246.12' }
        before do
          allow(Providers::GeolocationService).to receive(:call).and_raise(Providers::Exceptions::GeolocationError,
                                                                           'An error occurred')
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('An error occurred')
        end
      end
    end

    delete('delete geolocation') do
      tags 'Geolocations'
      produces 'application/json'
      security [Bearer: []]

      response(204, 'successful') do
        let(:ip_address) { '95.91.246.12' }
        run_test!
      end
    end
  end
end
