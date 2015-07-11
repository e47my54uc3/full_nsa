require 'rails_helper'
require 'spec_helper'
require 'airborne'
require 'timeout'


RSpec.describe GeoApiController, type: :controller do

  describe GeoApiController do
    context "successful responses" do
       it "should be for successful for 98% of queries" do
        get :index
        response.should be_successful
        json = JSON.parse(response.body)
    

        json["geo_api"].length.should be(100)
      end


      it "should return queries given a first and last name" do
        get :show, {:first_name => "Rosamond", :last_name => "Tromp", ip: "50.250.223.177"}
        response.should be_successful
        binding.pry



      end

    end
  end
end
