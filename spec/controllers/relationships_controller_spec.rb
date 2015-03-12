require 'spec_helper'

describe RelationshipsController do
  context "with authenticated user" do 
    before { set_authenticated_user }

    let(:jane) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
      
    describe "GET index" do
      it "sets @relationships to be the users that the current user is following" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        get :index 
        expect(assigns(:relationships)).to eq([relationship]) 
      end  
    end

    describe "POST create" do
      it "adds the follower/followed relationship if it does not already exist" do
        expect {
          post :create, followed_id: jane.id
        }.to change { Relationship.count }.from(0).to(1)  
      end 

      it "redirects to people_path for current user" do
        post :create, followed_id: jane.id
        expect(response).to redirect_to people_path  
      end  

      it "sets the flash success message" do
        post :create, followed_id: jane.id
        expect(flash[:success]).not_to be_blank
      end 

      it "does not add the follower/followed relationship if it already exists" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        expect {
          post :create, followed_id: jane.id
        }.to change { Relationship.count }.by 0  
      end  

      it "does not allow the user to follow themself" do
        expect {
          post :create, followed_id: authenticated_user.id
        }.to change { Relationship.count }.by 0  
      end  

      it "sets the flash danger message when person is already followed" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        post :create, followed_id: jane.id
        expect(flash[:danger]).not_to be_blank
      end   

    end  

    describe "DELETE destroy" do
      it "deletes the relationship if the current user is the follower" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        expect {
          delete :destroy, id: relationship.id
        }.to change { Relationship.count }.from(1).to(0)  
      end 

      it "redirects to people_path for current user" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path  
      end  

      it "sets the flash success message" do
        relationship = Fabricate(:relationship, follower: authenticated_user, followed: jane)
        delete :destroy, id: relationship.id
        expect(flash[:success]).not_to be_blank
      end    

      it "does not delete the relationship if the current user is not the follower" do
        relationship = Fabricate(:relationship, follower: bob, followed: jane)
        expect {
          delete :destroy, id: relationship.id
        }.to change { Relationship.count }.by 0  
      end 
    end  
  end

  context "with unauthenticated user" do
    it_behaves_like "redirect_for_unauthenticated_user" do
      let(:action) { get :index }
    end  

    it_behaves_like "redirect_for_unauthenticated_user" do
      let(:action) { delete :destroy, id: 1 }
    end  

    it_behaves_like "redirect_for_unauthenticated_user" do
      let(:action) { post :index, followed_id: 1 }
    end  
  end    
end