module Configurations

  def config_ip(string_ip)
    if IPAddress.valid?(string_ip) 
      puts "Ip is ok"
      get_ip_location(string_ip)
    else
      puts "Defaulting to an sf ip"
      get_ip_location("24.7.88.70")
    end
  end

  # def config_params
  #   @first_name, @last_name, @ip = params[:first_name], params[:last_name], params[:ip]
  # end

end