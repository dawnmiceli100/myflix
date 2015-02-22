shared_examples "redirect_for_unauthenticated_user" do 
  it "redirects to the sign in page" do
    clear_authenticated_user
    action
    expect(response).to redirect_to sign_in_path
  end   
end