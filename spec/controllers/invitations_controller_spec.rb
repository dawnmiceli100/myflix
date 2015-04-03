require 'spec_helper'

describe InvitationsController do
  context "with authenticated user" do
    before { set_authenticated_user }

    describe "GET new" do
      it "sets @invitation" do
        get :new
        expect(assigns(:invitation)).to be_new_record
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end  
    end 

    describe "POST create" do
      context "with valid input" do
        before { post :create, invitation: { invitee_name: "Jane Doe", invitee_email: "janedoe@example.com", message: "I think you'll like MyFlix!"}, token: "xxx" }
        
        after { ActionMailer::Base.deliveries.clear }

        it "creates the invitation" do
          expect(Invitation.count).to eq(1)
        end  

        it "sends the invitation email to the invitee" do
          expect(ActionMailer::Base.deliveries.first.to).to eq(["janedoe@example.com"]) 
        end

        it "sets the success message" do
          expect(flash[:success]).not_to be_blank
        end 

        it "redirects to new_invitation_path" do
          expect(response).to redirect_to new_invitation_path
        end    
      end 

      context "with invalid inputs" do
        before { post :create, invitation: { invitee_name: "Jane Doe", invitee_email: "janedoe@example.com"} }

        after { ActionMailer::Base.deliveries.clear }

        it "sets @invitation" do
          expect(assigns(:invitation)).to be_present
        end
          
        it "does not create the invitiation" do
          expect(Invitation.count).to eq(0)
        end
        
        it "does not send the invitation" do
          expect {
            post :create, invitation: { invitee_name: "Jane Doe", invitee_email: "janedoe@example.com"}
          }.not_to change { ActionMailer::Base.deliveries.count }  
        end 

        it "sets the danger message" do
          expect(flash[:danger]).not_to be_blank
        end 

        it "renders the new page" do
          expect(response).to render_template('new')
        end  
      end 
    end   
  end 

  context "with unauthenticated user" do
    describe "GET new" do 
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { get :new }
      end
    end  

    describe "POST create" do 
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { post :create }
      end
    end  
  end 
end