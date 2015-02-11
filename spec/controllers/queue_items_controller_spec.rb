require 'spec_helper'

describe QueueItemsController do 
  context "with authenticated user" do 

    let(:authenticated_user) { Fabricate(:user) } 
    before do
      session[:user_id] = authenticated_user.id 
    end 

    describe "GET index" do
      it "sets @queue_items for the user" do
        item1 = Fabricate(:queue_item, user: authenticated_user)
        item2 = Fabricate(:queue_item, user: authenticated_user)
        get :index 
        expect(assigns(:queue_items)).to match_array([item1, item2]) 
      end  
    end
  end 

  context "with unauthenticated user" do
    it "redirects to sign in page" do
      get :index 
      expect(response).to redirect_to sign_in_path 
    end  
  end       
end