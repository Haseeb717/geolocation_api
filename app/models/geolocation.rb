# frozen_string_literal: true

class Geolocation < ApplicationRecord
  validates :ip_address, presence: true, uniqueness: true
  validates :latitude, :longitude, :city, :country, presence: true
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: false
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: false
  validates :ip_address, format: { with: Resolv::IPv4::Regex, message: 'must be a valid IPv4 address' }
end
