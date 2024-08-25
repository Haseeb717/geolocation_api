# frozen_string_literal: true

# spec/services/providers/ipstack_service_spec.rb

require 'rails_helper'
require 'api_client'
require_relative '../../../app/exceptions/providers/errors'

RSpec.describe Providers::IpstackService, type: :service do
  let(:service) { described_class.new }
  let(:valid_ip) { '192.168.1.1' }
  let(:api_url) do
    "#{Providers::IpstackService::API_URL}#{valid_ip}?access_key=#{Providers::IpstackService::ACCESS_KEY}"
  end
  let(:response_data) { { city: 'Test City' } }

  before do
    allow(ApiClient).to receive(:get).with(api_url).and_return(response_data)
  end

  describe '#get_location' do
    it 'returns adapted location data' do
      allow(GeolocationAdapter).to receive(:new).with('ipstack',
                                                      response_data).and_return(double(adapt: { city: 'Test City' }))

      result = service.get_location(valid_ip)

      expect(result).to eq({ city: 'Test City' })
    end

    it 'raises a ServiceError for failed API requests' do
      allow(ApiClient).to receive(:get).and_return(nil)

      expect do
        service.get_location(valid_ip)
      end.to raise_error(Providers::Errors::ServiceError, 'Failed to fetch data from Ipstack')
    end
  end
end
