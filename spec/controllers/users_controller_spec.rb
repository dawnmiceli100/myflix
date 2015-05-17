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
      let(:stripeToken) { 'abc123' }

      context "with successful registration" do
        let(:registration) { double("registration", successful?: true) }
        before do
          UserRegistration
            .any_instance.should_receive(:register).and_return(registration)
          post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        end

        it "redirects to the sign in path" do
          expect(response).to redirect_to sign_in_path
        end
        
        it "sets the flash success message" do
          expect(flash[:success]).to be_present
        end  
      end

      context "with unsuccessful registration" do
        let(:registration) { double("registration", successful?: false, error_message: "Your card was declined.") }
        before do
          UserRegistration.any_instance.should_receive(:register).and_return(registration)
          post :create, user: { full_name: "Jane Doe", email: "jane@example.com", password: "password" }, stripeToken: stripeToken
        end

        it "renders the new template" do
          expect(response).to render_template('new')
        end

        it "sets the flash danger message" do
          expect(flash[:danger]).to be_present
        end 
      end
    end 

    context "with invalid input" do
      before do
        post :create, user: { full_name: "Jane Doe", email: "", password: "" }
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