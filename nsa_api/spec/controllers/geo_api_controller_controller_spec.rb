require 'rails_helper'
require 'spec_helper'



RSpec.describe GeoApiController, type: :controller do

 
    context "External gov.blockscore calls" do
      describe "get all files" do
        it "gets a response from the blockscore api" do
          VCR.use_cassette 'controller/gov_api_response' do
            request = Faraday.get("https://gov.blockscore.com/api/people")
            request.status.should be_in([200, 400])
          end
        end

        it "Checks that 100 user objects are returned from blockscore" do
          VCR.use_cassette 'controller/gov_api_response' do
            request = Faraday.get("https://gov.blockscore.com/api/people")
            response = JSON.parse(request.body)
            expect(response.length).to be(100)
          end
        end
      end

   context "nsa_api calls" do
    it "Should match the data provided to blockscore" do

      VCR.use_cassette 'controller/gov_api_response' do
        @request = Faraday.get("https://gov.blockscore.com/api/people")
        @request = JSON.parse(@request.body)

      end

      VCR.use_cassette 'controller/nsa_api_all' do
        @local = Faraday.get("http://localhost:3000")

        binding.pry
      end

    end

   end
    # context "process api calls gracefully" do
    #    it "should handle timeouts gracefully" do
    #     get :index
    #     response.status.should be_in([200, 408])
    #   end

    #   it "should be successful for 98% of queries" do
    #     get :index
    #     if response.status == 200
    #       json = JSON.parse(response.body)
    #       json["geo_api"].length.should be(100)
    #     end
    #   end
    # end

    # context "Get user specific location data" do
    #   it "should return a json object given a first and last name" do
    #     get :show, {:first_name => "Rosamond", :last_name => "Tromp", ip: "50.250.223.177"}

    #     if response.status == 200
    #       json = JSON.parse(response.body)
    #       json.length.should be(5)
    #     else
    #       response.status.should be(408)
    #     end
    #   end


    #   it "should return a 404 status if unavailable" do
    #     get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
    #     response.status.should be(404)
    #   end

    #   it "should return an error if a user data is unavailable" do
    #     get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
    #     json = JSON.parse(response.body)
    #     expect(json["error"]).to eq("No user location data available.")
    #   end

    # end

    
  end
end
