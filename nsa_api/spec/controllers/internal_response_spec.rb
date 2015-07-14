#will perform external api calls in order to complete internal operations

RSpec.describe GeoApiController, type: :controller do
 context "integration tests" do
    describe "process api calls gracefully" do
       it "should handle timeouts gracefully" do
        get :index
        expect(response.status).to be_in([200, 408])
      end

      it "should be successful for 98% of queries" do
        get :index
        if response.status == 200
          json = JSON.parse(response.body)
          expect(json["geo_api"].length).to be(100)
        end
      end
    end

    describe "Get user specific location data" do
      it "should return a json object given a first and last name" do
        get :show, {:first_name => "Rosamond", :last_name => "Tromp", ip: "50.250.223.177"}

        if response.status == 200
          json = JSON.parse(response.body)
          expect(json.length).to be(5)
        else
          expect(response.status).to be(408)
        end
      end


      it "should return a 404 status if unavailable" do
        get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
        expect(response.status).to be(404)
      end

      it "should return an error if a user data is unavailable" do
        get :show, {:first_name => "Raghu", :last_name => "Reddy", ip: "50.250.223.177"}
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("No user location data available.")
      end

    end

  end

end