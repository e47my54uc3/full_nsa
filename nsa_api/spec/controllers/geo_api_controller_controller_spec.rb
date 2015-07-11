require 'rails_helper'
require 'spec_helper'
require 'airborne'
require 'timeout'


RSpec.describe GeoApiController, type: :controller do

  describe GeoApiController do
    context "successful responses" do
       it "should be for successful for 98% of queries" do
        tested_resp = (get :index)
        response.should be_successful
        json = JSON.parse(response.body)
        binding.pry

        json["geo_api"].length.should be(100)
      end

    end
  end
end
