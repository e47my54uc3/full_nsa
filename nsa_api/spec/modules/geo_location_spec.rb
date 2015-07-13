require 'geo_location'

RSpec.configure do |c|
  c.include GeoLocation
end

RSpec.describe GeoLocation do

  context "distance calculations" do
    it "has access to the helper methods defined in the module" do
      test_location = distance_km([23, 53], [-2, 32])
      expect(test_location.present?).to be(true)
    end

    it "responds with the correct value" do
      expect(distance_km([23, 53], [-2, 32]).round(4)).to eq(3592.2678)
    end

  end



end