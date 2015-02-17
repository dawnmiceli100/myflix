require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do 
      before do
        set_authenticated_user
      end  

      context "with valid input" do
        before do
          post :create, review: { rating: 3, body: "This is the review body." }, video_id: video.id, current_user: authenticated_user          
        end
          
        it "saves the review when validations are successful" do
          expect(Review.count).to eq(1)
        end

        it "associates the saved review with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "associates the saved review with the authenticated user" do
          expect(Review.first.user.id).to eq(session[:user_id])
        end

        it "redirects_to the video_path when review is saved" do
          expect(response).to redirect_to video
        end

        it "sets the success message when the review is saved" do
          expect(flash[:success]).not_to be_blank
        end 
      end 

      context 'with invalid input' do
        it "does not create a Review record" do
          post :create, review: { rating: 3 }, video_id: video.id, current_user: authenticated_user
          expect(Review.count).to eq(0)
        end  

        it "sets @video" do
          post :create, review: { rating: 3 }, video_id: video.id, current_user: authenticated_user
          expect(assigns(:video)).to eq(video)
        end
        
        it "sets @reviews" do
          valid_review = Fabricate(:review, video: video)
          post :create, review: { rating: 3 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([valid_review])
        end

        it "sets the danger message when there are validation errors" do
          post :create, review: { rating: 3 }, video_id: video.id, current_user: authenticated_user
          expect(flash[:danger]).not_to be_blank
        end  

        it "renders the videos/show when there are validation errors" do
          post :create, review: { rating: 3 }, video_id: video.id, current_user: authenticated_user
          expect(response).to render_template 'videos/show'
        end  
      end        
    end

    context "with unauthenticated user" do
      it_behaves_like "redirect_for_unauthenticated_user" do
        let(:action) { post :create, review: { rating: 3, body: "This is the review body." }, video_id: video.id }
      end  
    end       
  end 
end