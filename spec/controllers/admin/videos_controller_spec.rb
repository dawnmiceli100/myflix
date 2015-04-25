require 'spec_helper'

describe Admin::VideosController do
  context "with authenticated user" do
    before { set_authenticated_user }

    describe "GET new" do
      context "with admin user" do
        it "sets the @video variable if the user is admin" do
          set_admin_user(authenticated_user)
          get :new
          expect(assigns(:video)).to be_new_record
          expect(assigns(:video)).to be_instance_of(Video)
        end 
      end
      
      context "with non-admin-user" do 
        it_behaves_like "redirect_for_non_admin_user" do
          let(:action) { get :new }
        end  
      end 
    end

    describe "POST create" do
      let(:category) { Fabricate(:category) }

      context "with admin user" do
        before { set_admin_user(authenticated_user) }

        context "with valid input" do
          before do
            post :create, video: { title: "Mary Poppins", description: "A Classic.", category_id: category.id }           
          end

          it "creates the video" do 
            expect(Video.count).to eq(1)
          end 

          it "associates the saved video with the category" do
            expect(Video.first.category).to eq(category)
          end

          it "redirects_to the new_admin_video_path when video is saved" do
            expect(response).to redirect_to new_admin_video_path
          end

          it "sets the success message when the video is saved" do
            expect(flash[:success]).not_to be_blank
          end 
        end 

        context "with invalid input" do
          before do
            post :create, video: { description: "A Classic.", category_id: category.id }
          end
            
          it "does not create a Video record" do
            expect(Video.count).to eq(0)
          end  

          it "sets the danger message when there are validation errors" do
            expect(flash[:danger]).not_to be_blank
          end  

          it "sets the @video variable" do
            expect(assigns(:video)).to be_present
          end  
          it "renders admin/videos/new when there are validation errors" do
            expect(response).to render_template 'admin/videos/new'
          end  
        end  
      end  

      context "with non-admin-user" do 
        it_behaves_like "redirect_for_non_admin_user" do
          let(:action)  { post :create, video: { title: "Mary Poppins", description: "A Classic.", category_id: category.id } }
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
        let(:action) { post :create, video: { title: "Mary Poppins", description: "A Classic." } }
      end
    end 
  end         
end