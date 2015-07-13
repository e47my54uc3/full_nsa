
module GeoLocation
  private
  
  def get_ip_coords(ip)
    resp = Faraday.get("http://ipinfo.io/#{ip}/json")
    coords = JSON.parse(resp.body)
    coords["loc"].split(',').map(&:to_f)
  end

  def distance_km(loc1, loc2) #geodistance via haversine formula
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers

    dlat_rad = (loc2.first-loc1.first) * rad_per_deg  # Delta, converted to rad

    dlon_rad = (loc2.last-loc1.last) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rkm * c # Delta in meters
  end

end