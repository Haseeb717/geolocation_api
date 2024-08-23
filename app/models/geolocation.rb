class Geolocation < ApplicationRecord
  validates :ip_address, presence: true, uniqueness: true
  validates :latitude, :longitude, :city, :country, presence: true
end
