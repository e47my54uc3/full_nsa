require 'configurations'
require 'geolocation'
require 'httprequests'


class GeoApiController < ApplicationController
  include Configurations
  include GeoLocation
  include HttpRequests
  
  def index
    request = timed_get_all
    return (render json: @delayed, status: 408) if @delayed

    render json: { geo_api: request.body}, status: 200   
  end


  def show
    first_name, last_name = params[:first_name], params[:last_name]

    ip_coords = config_ip_coords(params[:ip])

    user_info = timed_get_user(first_name, last_name)

    return (render json: @delayed, status: 408) if @delayed

    if user_info.empty?
      render json: {
                    error: "No user location data available.",
                    status: 404
                  }, status: 404
    else  
      parse_coords(user_info)

      phone_distance_from_ip = distance_km(@phone_coords, ip_coords)
      stated_distance_from_ip = distance_km(@stated_coords, ip_coords)
      stated_distance_from_phone = distance_km(@stated_coords, @phone_coords)
  
      render json: {first_name: first_name, 
                    last_name: last_name, 
                    phone_distance_from_ip: phone_distance_from_ip, 
                    stated_distance_from_ip: stated_distance_from_ip,
                    stated_distance_from_phone: stated_distance_from_phone
                    }, status: 200
    end
  end
end
