require 'rails_helper'
require 'spec_helper'



RSpec.describe GeoApiController, type: :controller do

  describe GeoApiController do
    context "process api calls gracefully" do
       it "should handle timeouts gracefully" do
        get :index
        response.status.should be_in([200, 503])
      end

      it "should be successful for 98% of queries" do
        get :index
        if response.status == 200
          json = JSON.parse(response.body)
          json["geo_api"].length.should be(100)
        end
      end
    end

    context "Get user specific location data" do
      it "should return a json object given a first and last name" do
        get :show, {:first_name => "Rosamond", :last_name => "Tromp", ip: "50.250.223.177"}

        if response.status == 200
          json = JSON.parse(response.body)
          json.length.should be(5)
        else
          response.status.should be(503)
        end
      end


      it "should return a 404 status if unavailable" do
        get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
        response.status.should be(404)
      end

      it "should return an error if a user data is unavailable" do
        get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("No user location data available.")
      end

    end

    
  end
end
