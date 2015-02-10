require 'spec_helper'

describe VideosController do
  context "with authenticated user" do
    before do
      session[:user_id] = Fabricate(:user).id
    end 

    describe "GET show" do
      it "sets the @video variable" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets the @reviews variable" do
        video = Fabricate(:video)
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review2, review1])
      end
    end 

    describe "POST search" do
      it "sets the @videos variable" do
        seabiscuit = Fabricate(:video, title: 'Seabiscuit')
        post :search, search_string: 'sea'
        expect(assigns(:videos)).to eq([seabiscuit])
      end
    end 

  end

  context "with unauthenticated user" do 
    describe "GET show" do 
      it "redirects to the sign_in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end      

    describe "POST search" do
      it "redirects to the sign_in page" do
        video = Fabricate(:video)
        post :search, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end      
  end

end