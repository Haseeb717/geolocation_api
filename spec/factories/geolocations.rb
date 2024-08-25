# frozen_string_literal: true

# spec/factories/geolocations.rb

FactoryBot.define do
  factory :geolocation do
    ip_address { '192.168.1.1' }
    url { 'https://example.com' }
    latitude { 37.7749 }
    longitude { -122.4194 }
    region_name { 'California' }
    city { 'San Francisco' }
    country { 'USA' }
    zip { '94103' }
  end
end
