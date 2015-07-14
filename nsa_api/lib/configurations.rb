module Configurations
  private
  
  def config_ip_coords(string_ip)
    if IPAddress.valid?(string_ip) 
      puts "Ip is ok"
      get_ip_coords(string_ip)
    else
      puts "Defaulting to an sf ip"
      get_ip_coords("24.7.88.70")
    end
  end

  def parse_coords(response)
      @phone_coords = [response[0]["phone_location"]["latitude"], response[0]["phone_location"]["longitude"]]
      @stated_coords = [response[0]["stated_location"]["latitude"], response[0]["stated_location"]["longitude"]]
  end

end