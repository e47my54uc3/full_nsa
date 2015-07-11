require 'geolocation'

class GeoApiController < ApplicationController
  include GeoLocation
  

  def index
    all_data = Thread.new do 
      @response = Unirest.get "https://gov.blockscore.com/api/people", 
                        headers:{ "Accept" => "application/json" }
    end
    start = Time.now
        all_data.join
    comp_time = Time.now

    if comp_time - start > 2 
     render json: {
        error: "Uh oh! We're experiencing heavy traffic right now.. please try again in a moment",
        status: 503
      }, status: 503
    else
      render json: @response.body
    end                 
  end


  def show
    first_name, last_name, ip = params[:first_name], params[:last_name], params[:ip]

    ip_data = config_ip(ip)
    # binding.pry
   
    ip_location = ip_data.body["loc"].split(',').map(&:to_f)
 
    user_data = Thread.new do 
      @response = Unirest.get "https://gov.blockscore.com/api/people", 
                        headers:{ "Accept" => "application/json" }
    end

    start = Time.now
    user_data.join
    comp_time = Time.now

    if comp_time - start > 2 
         render json: {
                        error: "Uh oh! We're experiencing heavy traffic right now.. please try again in a moment.",
                        status: 503
                      }, status: 503
    else
        found = @response.body.select do |person|
          person["last_name"] == last_name && person["first_name"] == first_name
        end

        if found.empty?
          render json: {
                        error: "No user location data available.",
                        status: 404
                      }, status: 404
        else

          phone_coords = [found[0]["phone_location"]["latitude"], found[0]["phone_location"]["longitude"]]
          stated_coords = [found[0]["stated_location"]["latitude"], found[0]["stated_location"]["longitude"]]

          
          
          phone_distance_from_ip = distance_km(phone_coords, ip_location)
          stated_distance_from_ip = distance_km(stated_coords, ip_location)
          stated_distance_from_phone = distance_km(stated_coords, phone_coords)
          

          render json: {first_name: first_name, 
                        last_name: last_name, 
                        phone_distance_from_ip: phone_distance_from_ip, 
                        stated_distance_from_ip: stated_distance_from_ip,
                        stated_distance_from_phone: stated_distance_from_phone
                        }, status: 200
        end
    end
  end
end
