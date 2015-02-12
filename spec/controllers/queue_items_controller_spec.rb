require 'spec_helper'

describe QueueItemsController do 
  context "with authenticated user" do 

    let(:authenticated_user) { Fabricate(:user) } 
    before do
      session[:user_id] = authenticated_user.id 
    end 

    describe "GET index" do
      it "sets @queue_items for the user" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        item1 = Fabricate(:queue_item, user: authenticated_user, video: video1)
        item2 = Fabricate(:queue_item, user: authenticated_user, video: video2)
        get :index 
        expect(assigns(:queue_items)).to match_array([item1, item2]) 
      end  
    end

    describe "POST create" do
      it "creates a queue_item for the video if the video is not in queue_items for the current_user" do
        video = Fabricate(:video, title: "Mary Poppins")
        post :create, queue_item: { queue_position: nil, video_id: video.id }, video_id: video.id
        expect(QueueItem.last.video.title).to eq("Mary Poppins")
      end
      it "associates the queue_item with the current_user" do
        video = Fabricate(:video)
        post :create, queue_item: { queue_position: nil, user_id: authenticated_user.id }, video_id: video.id
        expect(QueueItem.last.user_id).to eq(authenticated_user.id)
      end
      it "associates the queue_item with the video" do
        video = Fabricate(:video)
        post :create, queue_item: { queue_position: nil, video_id: video.id }, video_id: video.id
        expect(QueueItem.last.video_id).to eq(video.id)
      end
      it "sets the queue_item.queue_position to the last position in the user queue" do
        video1 = Fabricate(:video)
        item1 = Fabricate(:queue_item, video: video1, user: authenticated_user)
        video2 = Fabricate(:video)
        post :create, queue_item: { queue_position: nil, user_id: authenticated_user.id, video_id: video2.id }, video_id: video2.id
        expect(authenticated_user.queue_items.last.queue_position).to eq(2)
      end  
      it "does not create the queue_item if there is already a queue_item for that user/video combination" do
        item_count = authenticated_user.queue_items.count
        video = Fabricate(:video)
        item = Fabricate(:queue_item, video: video, user: authenticated_user)
        post :create, queue_item: { queue_position: nil, user_id: authenticated_user.id, video_id: video.id }, video_id: video.id
        expect(authenticated_user.queue_items.count).to eq(item_count + 1)
      end
      it "redirects to my_queue page" do
        video = Fabricate(:video)
        post :create, queue_item: { queue_position: nil, user_id: authenticated_user.id, video_id: video.id }, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end 
    end  
  end 

  context "with unauthenticated user" do
    it "redirects to sign in page for index action" do
      get :index 
      expect(response).to redirect_to sign_in_path 
    end  

    it "redirects to sign in page for create action" do
      video = Fabricate(:video)
      post :create, queue_item: { queue_position: nil }, video_id: video.id
      expect(response).to redirect_to sign_in_path 
    end  
  end       
end