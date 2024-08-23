# frozen_string_literal: true

# app/serializers/geolocation_serializer.rb

class GeolocationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :ip_address, :latitude, :longitude, :city, :region, :country, :zip_code, :created_at, :updated_at
end
