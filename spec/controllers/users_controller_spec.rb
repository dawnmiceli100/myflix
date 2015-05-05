require 'spec_helper'
require 'stripe_mock'

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

  describe "GET new_with_invitation_token" do
    it "sets the email of @user with the invitee's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.invitee_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end  
 
    it "renders the new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template('new')
    end  
    
    it "redirects to expired token page if token is invalid" do
      get :new_with_invitation_token, token: 'xxx'
      expect(response).to redirect_to expired_token_path
    end  
  end   

  describe "POST create" do

    context "with valid input" do
      let(:stripe_helper) { StripeMock.create_test_helper }
      let(:stripeToken) { stripe_helper.generate_card_token }
      before { StripeMock.start}
      after do
        ActionMailer::Base.deliveries.clear
        StripeMock.stop
      end  

      it "creates a User record" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        expect(User.last.full_name).to eq("Jane Doe") 
      end

      it "redirects to sign_in_path" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        expect(response).to redirect_to sign_in_path
      end

      it "sends out the welcome email" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        expect(ActionMailer::Base.deliveries).not_to be_blank  
      end 

      it "sends the welcome email to the correct user" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["jane@example.com"])    
      end 

      it "sends the welcome email with the right content" do
        post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        email = ActionMailer::Base.deliveries.last
        expect(email.body).to include("Jane Doe")    
      end 

      context "with invitation" do
        let(:bob) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: bob, invitee_name: "Jane", invitee_email: "jane@example.com") }
        
        before do
          post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, invitation_token: invitation.token, stripeToken: stripeToken
        end  

        let(:jane) { User.find_by(email: "jane@example.com") }

        it "adds the relationship where the user follows the inviter" do 
          expect(jane.follows?(bob)).to be_truthy
        end 

        it "adds the relationship where the inviter follows the user" do 
          expect(bob.follows?(jane)).to be_truthy
        end 

        it "expires the invitation" do
          expect(Invitation.first.token).to be_nil
        end  
      end  
    end  

    context "with invalid input" do
      let(:initial_user_count) { User.count }
      before do
        post :create, user: { full_name: "", email: "jane@example.com", password: "password" }
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
        }.not_to change { ActionMailer::Base.deliveries.count }    
      end 
    end 
  end   
end