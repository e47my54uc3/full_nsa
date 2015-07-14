require 'geo_location'

RSpec.configure do |c|
  c.include GeoLocation
end

RSpec.describe GeoLocation do

  describe "distance calculations" do
    let (:test_location) {distance_km([23, 53], [-2, 32])}

    it "has access to the helper methods defined in the module" do
      expect(test_location.present?).to be(true)
    end

    it "responds with the correct value" do
      expect(test_location.round(4)).to eq(3592.2678)
    end
  end

  describe "parsing coordinates" do
    let(:coordinates) { get_ip_coords("208.184.96.233") }

    it "returns an array of longtitude and latitude coordinates" do
      expect(coordinates.class).to be(Array)
    end

    it "returns a float representing the latitude and longtitude" do
      expect(coordinates.first.class).to be(Float) 
      expect(coordinates.last.class).to be(Float)
    end

  end



end