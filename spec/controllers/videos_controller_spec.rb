require 'spec_helper'

describe VideosController do
  context "with authenticated user" do
    before { set_authenticated_user }

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
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { get :show, id: 1 }
      end
    end      

    describe "POST search" do
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { post :search, id: 1 }
      end
    end      
  end

end