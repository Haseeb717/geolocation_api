# lib/api_client.rb
require 'httparty'

class ApiClient
  include HTTParty

  default_timeout 15

  def self.get(url, headers = {})
    response = HTTParty.get(url, headers: headers)
    handle_response(response)
  rescue Net::OpenTimeout, Net::ReadTimeout
    raise Providers::Exceptions::ServiceError, 'API request timed out'
  rescue HTTParty::Error => e
    raise Providers::Exceptions::ServiceError, "HTTParty error occurred: #{e.message}"
  rescue StandardError => e
    raise Providers::Exceptions::ServiceError, "Unexpected error occurred: #{e.message}"
  end

  private

  def self.handle_response(response)
    case response.code
    when 200
      JSON.parse(response.body)
    else
      handle_error(response)
    end
  end

  def self.handle_error(response)
    raise Providers::Exceptions::ServiceError, "API Request failed with response code #{response.code}: #{response.message}"
  end
end
