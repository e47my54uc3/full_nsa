require 'config_coordinates'
require 'geo_location'
require 'http_requests'

class GeoApiController < ApplicationController
  include ConfigCoordinates
  include GeoLocation
  include HttpRequests

        #Documentation specific DSL:
        api :GET, "/index", "List all user data provided by the NSA."
        error :code => 408, :desc => "Request timeout"
        #End of documentation for /index
        
  def index
    request = timed_get_all
    return (render json: @delayed, status: 408) if @delayed
    render json: { geo_api: request.body}, status: 200   
  end

        api :GET, "/location", "Get location data specific to a User."
        param :user, Hash, :desc => 'User hash required for location data', :required => true do
          param :first_name, String, :desc => "First name of person", :required => true
          param :last_name, String, :desc => "Last name of person", :required => true
          param :ip, String, :desc => "Optional IP address", :required => false
        end
        error :code => 408, :desc => "Request timeout"
        error :code => 404, :desc => "User location data unavailable"

  def show
    ip_coords = config_ip_coords(params[:ip])
    user_info = timed_get_user(params[:first_name], params[:last_name])

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
  
      render json: {first_name: params[:first_name], 
                    last_name: params[:last_name], 
                    phone_distance_from_ip: phone_distance_from_ip, 
                    stated_distance_from_ip: stated_distance_from_ip,
                    stated_distance_from_phone: stated_distance_from_phone
                    }, status: 200
    end
  end
end
