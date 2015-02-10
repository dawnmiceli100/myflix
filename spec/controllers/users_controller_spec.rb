require 'spec_helper'

describe UsersController do 

  describe 'GET new' do
    it "sets the @user variable when the input is valid" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end  

  describe "POST create" do

    context "with valid input" do
      before do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password"}
      end  

      it "creates a User record" do
        expect(User.first.full_name).to eq("Jane Doe") 
      end
      
      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
      end
    end  

    context "with invalid input" do
      before do
        post :create, user: { full_name: "", email: "jane@example.com", password: "password"}
      end  

      it "does not create a User record" do
        expect(User.count).to eq 0
      end  

      it "sets the @user variable" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
      end  

      it "renders the new template" do
        expect(response).to render_template('new')
      end  
    end  
  end   
end