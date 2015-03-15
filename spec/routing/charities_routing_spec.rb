require "spec_helper"

describe CharitiesController do
  describe "routing" do

    it "routes to #new" do
      get("/charities/new").should route_to("charities#new")
    end

    it "routes to #show" do
      get("/charities/1").should route_to("charities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/charities/1/edit").should route_to("charities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/charities").should route_to("charities#create")
    end

    it "routes to #update" do
      put("/charities/1").should route_to("charities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/charities/1").should route_to("charities#destroy", :id => "1")
    end

    it "routes to #current_status" do
      get("/charities/dashboard/current-status").should route_to("charities#current_status")
    end

    it "routes to #approvals_new_staff" do
      get("/charities/dashboard/approvals-new-staff").should route_to("charities#approvals_new_staff")
    end
  end
end
