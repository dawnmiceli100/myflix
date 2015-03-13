require 'spec_helper'

describe UsersController do 

  describe 'GET show' do
    context "with authenticated user" do
      before { set_authenticated_user }

      it "sets the @user variable" do
        get :show, id: authenticated_user.id
        expect(assigns(:user).full_name).to eq(authenticated_user.full_name)
      end 
    end 

    context "with unauthenticated user" do
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { get :show, id:('') }
      end  
    end      
  end  

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
        expect(User.last.full_name).to eq("Jane Doe") 
      end
      
      it "redirects to sign_in_path" do
        expect(response).to redirect_to sign_in_path
      end

      it "sends out the welcome email" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password"}
        expect(ActionMailer::Base.deliveries).not_to be_blank  
      end 

      it "sends the welcome email to the correct user" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password"}
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["jane@example.com"])    
      end 

      it "sends the welcome email with the right content" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password"}
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Congratulations")    
      end 
    end  

    context "with invalid input" do
      let(:initial_user_count) { User.count }
      before do
        post :create, user: { full_name: "", email: "jane@example.com", password: "password"}
      end  

      it "does not create a User record" do
        expect(User.count).to eq initial_user_count 
      end  

      it "sets the @user variable" do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
      end  

      it "renders the new template" do
        expect(response).to render_template('new')
      end 

      it "does not send out the welcome email" do
        expect {
          post :create, user: { full_name: "", email: "jane@example.com", password: "password" }
        }.to change { ActionMailer::Base.deliveries.count }.by 0    
      end 
    end 

  end   
end