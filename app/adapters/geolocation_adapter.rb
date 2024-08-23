# app/adapters/geolocation_adapter.rb
class GeolocationAdapter
  def initialize(provider, data)
    @provider = provider
    @data = data
  end

  def adapt
    adapter_class.new(@data).call
  end

  private

  def adapter_class
    case @provider.to_sym
    when :ipstack
      IpstackAdapter
    # when :another_provider
      # AnotherProviderAdapter
    else
      raise "Adapter for provider #{@provider} not implemented"
    end
  end
end
