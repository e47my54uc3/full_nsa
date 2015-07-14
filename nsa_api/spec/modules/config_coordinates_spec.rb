require 'config_coordinates'
require 'geo_location'

RSpec.configure do |c|
  c.include ConfigCoordinates
  c.include GeoLocation
end

RSpec.describe ConfigCoordinates do

  describe "Configuring an IP" do
    it "returns coordinates for a valid IP" do
      expect(config_ip_coords("208.184.96.233")).to eq(get_ip_coords("208.184.96.233"))
    end

    it "default to an sf IP for invalid coordinates" do
      expect(config_ip_coords("testaroo")).to eq(get_ip_coords("24.7.88.70"))
    end
  end

end