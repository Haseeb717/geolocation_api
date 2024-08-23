# app/adapters/ipstack_adapter.rb
class IpstackAdapter
  def initialize(data)
    @data = data
  end

  def call
    {
      ip_address: @data['ip'],
      country: @data['country_name'],
      region_name: @data['region_name'],
      city: @data['city'],
      zip: @data['zip'],
      latitude: @data['latitude'],
      longitude: @data['longitude']
    }
  end
end
