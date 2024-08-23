# frozen_string_literal: true

# app/exceptions/providers/errors.rb

module Providers
  module Exceptions
    class GeolocationError < StandardError; end
    class UnsupportedProviderError < GeolocationError; end
    class ServiceError < GeolocationError; end
    class InvalidInputError < GeolocationError; end
  end
end
