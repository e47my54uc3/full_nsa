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
            @response = JSON.parse(request.body)
            expect(response.length).to be(100)
          end
        end
      end
    end

end
