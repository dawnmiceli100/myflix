require 'spec_helper'

describe Admin::VideosController do
  context "with authenticated user" do
    before { set_authenticated_user }

    describe "GET new" do
      it "sets the @video variable if the user is admin" do
        set_admin_user(authenticated_user)
        get :new
        expect(assigns(:video)).to be_new_record
        expect(assigns(:video)).to be_instance_of(Video)
      end 

      it "redirects to home_path if user is not admin" do
        get :new
        expect(response).to redirect_to home_path
      end 

      it "sets the danger message if the user is not admin" do
        get :new
        expect(flash[:danger]).not_to be_blank
      end  
    end
  end
  
  context "with unauthenticated user" do 
    describe "GET new" do 
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { get :new }
      end
    end 
  end         

end