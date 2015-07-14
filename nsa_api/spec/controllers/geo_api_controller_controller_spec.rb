require 'rails_helper'
require 'spec_helper'
require 'uri'

RSpec.describe GeoApiController, type: :controller do

    context "External gov.blockscore calls" do
      describe "get all files" do
        it "gets a response from the blockscore api" do
          VCR.use_cassette 'controller/gov_api_response' do
            request = Faraday.get("https://gov.blockscore.com/api/people")
            request.status.should be_in([200, 408])
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
          VCR.use_cassette('controller/all_internal_data') do
            request = Net::HTTP.get_response('localhost', '/', 3000).body

            expect(JSON.parse(request)["geo_api"].length).to be(100)
          end
        end

        it "Checks that the proper status is returned" do
          VCR.use_cassette('controller/all_internal_data') do
            request = Net::HTTP.new('localhost', 3000).get('/')
            expect(request.code.to_i).to be_in([200, 408])
          end
        end
      end

      describe "get specific user object" do
        it "Gets a specific users object given params" do
          VCR.use_cassette('controller/specific_internal_data') do
            request = Net::HTTP.new('localhost', 3000).get('/location?last_name=Tromp&first_name=Rosamond')
            request = Net::HTTP.get_response('localhost', '/location?last_name=Tromp&first_name=Rosamond', 3000).body

            data = JSON.parse(request)
            expect(data["stated_distance_from_phone"]).to be_a(Float)
          end
        end
      end 

      describe "get specific user object" do
        it "responds with the appropriate status" do
          VCR.use_cassette('controller/specific_internal_data') do
            request = Net::HTTP.new('localhost', 3000).get('/location?last_name=Tromp&first_name=Rosamond')
            request = Net::HTTP.get_response('localhost', '/location?last_name=Tromp&first_name=Rosamond', 3000)

            code = (request.code.to_i)
            expect(code).to be_in([200, 408])
          end
        end
      end 
    end

end
