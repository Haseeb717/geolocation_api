# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Geolocations', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => user.api_key.to_s } }

  describe 'GET /api/v1/geolocations' do
    let!(:geolocation1) { create(:geolocation, ip_address: '192.168.1.1') }
    let!(:geolocation2) { create(:geolocation, ip_address: '192.168.1.2') }

    it 'returns a list of geolocations' do
      get('/api/v1/geolocations', headers:)

      expect(response).to have_http_status(:ok)
      expect(json['data'].length).to eq(2)
    end

    it 'filters geolocations by ip_address' do
      get('/api/v1/geolocations', params: { ip_address: '192.168.1.1' }, headers:)

      expect(response).to have_http_status(:ok)
      expect(json['data'].length).to eq(1)
      expect(json['data'][0]['attributes']['ip_address']).to eq('192.168.1.1')
    end
  end

  describe 'GET /api/v1/geolocations/:ip_address' do
    let!(:geolocation) { create(:geolocation, ip_address: '192.168.1.1') }

    it 'returns the geolocation when it exists' do
      get("/api/v1/geolocations/#{geolocation.ip_address}", headers:)
      expect(response).to have_http_status(:success)
      expect(json['data']['attributes']['ip_address']).to eq(geolocation.ip_address)
    end
  end

  describe 'DELETE /api/v1/geolocations/:ip_address' do
    let!(:geolocation) { create(:geolocation, ip_address: '192.168.1.1') }

    context 'when the geolocation exists' do
      it 'deletes the geolocation' do
        delete("/api/v1/geolocations/#{geolocation.ip_address}", headers:)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the geolocation does not exist' do
      it 'returns a not found message' do
        delete('/api/v1/geolocations/invalid_ip', headers:)

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Geolocation not found')
      end
    end
  end
end
