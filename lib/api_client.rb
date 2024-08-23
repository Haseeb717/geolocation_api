# lib/api_client.rb
require 'httparty'

class ApiClient
  include HTTParty

  # Default options for HTTParty
  default_timeout 15

  def self.get(url, headers = {})
    response = HTTParty.get(url, headers: headers)

    handle_response(response)
  rescue Net::OpenTimeout, Net::ReadTimeout
    raise StandardError, 'API request timed out'
  rescue HTTParty::Error => e
    raise StandardError, "HTTParty error occurred: #{e.message}"
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
    raise StandardError, "API Request failed with response code #{response.code}: #{response.message}"
  end
end
