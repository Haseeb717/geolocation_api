# frozen_string_literal: true

# app/services/providers/geolocation_service.rb

require 'api_client'
require 'uri'
require 'resolv'

module Providers
  class GeolocationService
    PROVIDERS = {
      ipstack: 'Providers::IpstackService'
      # Add more providers here as needed
    }.freeze

    def self.call(provider, ip_or_url)
      service = find_provider(provider)
      ip = extract_ip(ip_or_url)

      service.get_location(ip)
    rescue Providers::Exceptions::GeolocationError => e
      raise e
    rescue StandardError => e
      raise Providers::Exceptions::ServiceError, "An unexpected error occurred: #{e.message}"
    end

    def get_location(ip_or_url)
      raise NotImplementedError, 'This method should be overridden in a subclass'
    end

    def self.find_provider(provider)
      provider_class = PROVIDERS[provider.to_sym]

      raise Providers::Exceptions::UnsupportedProviderError, provider unless provider_class.present?

      provider_class.constantize.new
    end

    def self.ip_address?(input)
      # Check if the input is a valid IPv4 or IPv6 address
      !!(input =~ Resolv::IPv4::Regex || input =~ Resolv::IPv6::Regex)
    end

    def self.url?(input)
      # Check if the input is a valid URL
      uri = URI.parse(input)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end

    def self.resolve_ip_from_url(url)
      # Extract IP address from URL
      uri = URI.parse(url)
      Resolv.getaddress(uri.host)
    rescue Resolv::ResolvError => e
      raise ArgumentError, "Unable to resolve IP address from URL: #{e.message}"
    end

    def self.extract_ip(ip_or_url)
      if ip_address?(ip_or_url)
        ip_or_url
      elsif url?(ip_or_url)
        resolve_ip_from_url(ip_or_url)
      else
        raise Providers::Exceptions::InvalidInputError, 'Invalid IP address or URL'
      end
    end
  end
end
