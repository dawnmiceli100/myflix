require 'spec_helper'

describe SessionsController do 
  context "user is signed in" do
    before do
      session[:user_id] = Fabricate(:user).id
    end  

    describe "GET new" do
      it "redirects to home_path" do
        get :new
        expect(response).to redirect_to home_path
      end  
    end
      
    describe "GET destroy" do
      before do
        get :destroy
      end 

      it "sets session[:user_id] to nil" do
        expect(session[:user_id]).to eq nil
      end

      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end

      it "sets the success message" do
        expect(flash[:success]).not_to be_blank
      end   
    end  
  end

  context "user is not signed in" do

    describe "GET new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template('new')
      end  
    end  

    describe "POST create" do
      let(:user) { Fabricate(:user) }

      context "with valid email and password" do
        before do
          post :create, email: user.email, password: user.password  
        end  

        it "sets session[:user_id]" do
          expect(session[:user_id]).to eq user.id
        end 

        it "redirects to home_path" do
          expect(response).to redirect_to home_path
        end 

        it "sets the success message" do
          expect(flash[:success]).not_to be_blank
        end 
      end  

      context "with invalid email and/or password" do
        it "sets session[:user_id] to nil" do
          post :create, email: 'email', password: user.password
          expect(session[:user_id]).to eq nil
        end 

        it "redirects to sign_in_path when user enters invalid email" do
          post :create, email: 'email', password: user.password
          expect(response).to redirect_to sign_in_path
        end  

        it "redirects to sign_in_path when user enters invalid password" do
          post :create, email: user.email, password: "invalid"
          expect(response).to redirect_to sign_in_path
        end 

        it "sets the error message" do
          post :create, email: user.email, password: "invalid"
          expect(flash[:error]).not_to be_blank
        end  
      end  
    end  
  end  
end