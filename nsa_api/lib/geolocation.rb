
module GeoLocation
  private
  
  def config_ip(string_ip)
    if IPAddress.valid?(string_ip) 
      puts "Ip is ok"
      get_ip_location(string_ip)
    else
      puts "Defaulting to an sf ip"
      get_ip_location("24.7.88.70")
    end
  end

  def get_ip_location(ip)
    Unirest.get "http://ipinfo.io/#{ip}", #will default to an ip, get geo location
                        headers:{ "Accept" => "application/json" }
  end

  def distance_km(loc1, loc2) #geodistance via haversine formula
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rkm * c # Delta in meters
  end

end