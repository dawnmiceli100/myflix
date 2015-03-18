require 'spec_helper'

describe ResetPasswordsController do 

  describe "POST create" do
    context "with valid email address" do
      let(:jane) { Fabricate(:user) }

      it "renders the email sent page" do
        post :create, email: jane.email
        expect(response).to render_template('email_sent') 
      end
    end  

    context "with blank or invalid email address" do
      it "renders the email sent page" do
        post :create, email: 'bob@example.com'
        expect(response).to render_template('email_sent') 
      end 

      it "does not sets the danger message" do
        post :create, email: 'bob@example.com'
        expect(flash[:danger]).to be_blank
      end  
    end  
  end 

  describe "GET edit" do
    it "sets @user variable" do
      jane = Fabricate(:user, reset_token: "xxx") 
      get :edit, id: "xxx" 
      expect(assigns(:user)).to eq(jane) 
    end  
  end

  describe "PATCH update" do
    it "sets @user variable" do
      jane = Fabricate(:user, reset_token: 'xxx', reset_sent_at: Time.zone.now) 
      patch :update, id: jane.id, user: { password: 'new' } 
      expect(assigns(:user)).to eq(jane) 
    end  

    context "with blank new password" do
      let(:jane) { Fabricate(:user, reset_token: 'xxx', reset_sent_at: Time.zone.now) }

      it "renders the edit page" do
        patch :update, id: jane.id, user: { password: '' }
        expect(response).to render_template('edit') 
      end 

      it "sets the danger message" do
        patch :update, id: jane.id, user: { password: '' }
        expect(flash[:danger]).not_to be_blank
      end  
    end  

    context "with expired reset_sent_at date" do
      let(:jane) { Fabricate(:user, reset_sent_at: Time.zone.now - 1.day) }

      it "redirects to new_reset_password_path" do
        patch :update, id: jane.id, user: { password: 'new' }
        expect(response).to redirect_to new_reset_password_path
      end 

      it "sets the danger message" do
        patch :update, id: jane.id, user: { password: 'new' }
        expect(flash[:danger]).not_to be_blank
      end  
    end  

    context "with valid password" do
      let(:jane) { Fabricate(:user, reset_token: 'xxx', reset_sent_at: Time.zone.now) }

      it "updates the password" do
        new_password = 'new'
        patch :update, id: jane.id, user: { password: new_password }
        expect(User.first.authenticate(new_password)).to be_truthy
      end
        
      it "redirects to sign_in_path" do
        patch :update, id: jane.id, user: { password: 'new' }
        expect(response).to redirect_to sign_in_path
      end 

      it "sets the success message" do
        patch :update, id: jane.id, user: { password: 'new' }
        expect(flash[:success]).not_to be_blank
      end  
    end  
  end 
end