require 'rails_helper'
require 'spec_helper'
require 'uri'

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

            # uri = URI.parse("http://localhost:3000/location"); params = {:first_name => 'Rosamond', :last_name => 'Tromp'}
            # uri.query = URI.encode_www_form(params)

            # binding.pry
            # response = Net::HTTP.get(uri)
            # encoded_params = URI.encode_www_form(params)
            # [path, encoded_params].join("?")

            # http = Net::HTTP.new(uri.host, 3000)
            # request = Net::HTTP.get(uri.path)
            request = Net::HTTP.new('localhost', 3000).get('/location?last_name=Tromp&first_name=Rosamond')


            binding.pry
            expect(request.code.to_i).to be_in([200, 408])
          end
        end
      end 
    end

end
