# frozen_string_literal: true

# app/serializers/geolocation_serializer.rb

class GeolocationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :ip_address, :latitude, :longitude, :city, :region_name, :country, :zip, :created_at, :updated_at
end
