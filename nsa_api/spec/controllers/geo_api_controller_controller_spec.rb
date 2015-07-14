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
    end

    context "Internal calls" do
      describe "get all internal user objects" do
        it "Checks that 100 objects are returned" do
          VCR.use_cassette('controller/all_internal_data', :record => :new_episodes) do
            request = Net::HTTP.get_response('localhost', '/', 3000).body

            binding.pry
            expect(JSON.parse(request)["geo_api"].length).to be(100)

          end

        end

      end 


    end

end
