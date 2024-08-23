class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :ip_address
      t.string :url
      t.float :latitude
      t.float :longitude
      t.string :region_name
      t.string :city
      t.string :country
      t.string :zip

      t.timestamps
    end
  end
end
