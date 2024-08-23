# frozen_string_literal: true

# app/services/providers/ipstack_service.rb
module Providers
  class IpstackService < GeolocationService
    API_URL = 'http://api.ipstack.com/'
    ACCESS_KEY = ENV['IPSTACK_API_KEY']

    def get_location(ip_or_url)
      url = "#{API_URL}#{ip_or_url}?access_key=#{ACCESS_KEY}"
      response_data = ApiClient.get(url)

      raise Providers::Exceptions::ServiceError, 'Failed to fetch data from Ipstack' unless response_data

      GeolocationAdapter.new('ipstack', response_data).adapt
    end
  end
end
