# frozen_string_literal: true

# spec/services/providers/geolocation_service_spec.rb

require 'rails_helper'
require 'api_client'
require_relative '../../../app/exceptions/providers/errors'

RSpec.describe Providers::GeolocationService, type: :service do
  let(:provider) { :ipstack }
  let(:valid_ip) { '192.168.1.1' }
  let(:valid_url) { 'http://example.com' }
  let(:invalid_input) { 'invalid_input' }

  describe '.call' do
    context 'when the input is a valid IP address' do
      it 'calls the provider service and returns location data' do
        allow_any_instance_of(Providers::IpstackService).to receive(:get_location).with(valid_ip)
                                                                                  .and_return({ city: 'Test City' })

        result = Providers::GeolocationService.call(provider, valid_ip)

        expect(result).to eq({ city: 'Test City' })
      end
    end

    context 'when the input is a valid URL' do
      before do
        allow_any_instance_of(Providers::IpstackService).to receive(:get_location).and_return({ city: 'Test City' })
        allow(Providers::GeolocationService).to receive(:resolve_ip_from_url).with(valid_url).and_return(valid_ip)
      end

      it 'resolves the URL to an IP address and returns location data' do
        result = Providers::GeolocationService.call(provider, valid_url)

        expect(result).to eq({ city: 'Test City' })
      end
    end

    context 'when the input is invalid' do
      it 'raises an InvalidInputError' do
        expect do
          Providers::GeolocationService.call(provider, invalid_input)
        end.to raise_error(Providers::Exceptions::InvalidInputError, 'Invalid IP address or URL')
      end
    end

    context 'when the provider is unsupported' do
      it 'raises an UnsupportedProviderError' do
        expect do
          Providers::GeolocationService.call(:unsupported_provider, valid_ip)
        end.to raise_error(Providers::Exceptions::UnsupportedProviderError)
      end
    end

    context 'when there is a service error' do
      it 'raises a ServiceError' do
        allow_any_instance_of(Providers::IpstackService).to receive(:get_location)
          .and_raise(Providers::Exceptions::GeolocationError)

        expect do
          Providers::GeolocationService.call(provider, valid_ip)
        end.to raise_error(Providers::Exceptions::GeolocationError)
      end

      it 'raises a ServiceError for unexpected errors' do
        allow_any_instance_of(Providers::IpstackService).to receive(:get_location).and_raise(StandardError,
                                                                                             'Unexpected error')

        expect do
          Providers::GeolocationService.call(provider, valid_ip)
        end.to raise_error(Providers::Exceptions::ServiceError, /An unexpected error occurred/)
      end
    end
  end

  describe '.ip_address?' do
    it 'returns true for a valid IP address' do
      expect(Providers::GeolocationService.ip_address?('192.168.1.1')).to be true
    end

    it 'returns false for an invalid IP address' do
      expect(Providers::GeolocationService.ip_address?('invalid_ip')).to be false
    end
  end

  describe '.url?' do
    it 'returns true for a valid URL' do
      expect(Providers::GeolocationService.url?('http://example.com')).to be true
    end

    it 'returns false for an invalid URL' do
      expect(Providers::GeolocationService.url?('invalid_url')).to be false
    end
  end

  describe '.resolve_ip_from_url' do
    it 'resolves IP address from a valid URL' do
      allow(Resolv).to receive(:getaddress).with('example.com').and_return('93.184.216.34')

      expect(Providers::GeolocationService.resolve_ip_from_url('http://example.com')).to eq('93.184.216.34')
    end

    it 'raises an error for unresolved URLs' do
      allow(Resolv).to receive(:getaddress).and_raise(Resolv::ResolvError)

      expect do
        Providers::GeolocationService.resolve_ip_from_url('http://invalid-url.com')
      end.to raise_error(ArgumentError)
    end
  end
end
