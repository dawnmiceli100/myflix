require 'spec_helper'

feature "view payments functionality" do
  background do
    bob = Fabricate(:user, full_name: "Bob Miller", email: "bobmiller@example.com")
    payment = Fabricate(:payment, user: bob, stripe_charge_id: "ch-123")  
  end 

  scenario "an admin user sees payments made by other users" do 
    admin = Fabricate(:user, admin: true)

    sign_in(admin)
    visit(admin_payments_path)
    
    expect(page).to have_content("Bob Miller")
    expect(page).to have_content("bobmiller@example.com")
    expect(page).to have_content("$9.99")
    expect(page).to have_content("ch-123")   
  end

  scenario "a non-admin cannot see any payments" do 
    non_admin = Fabricate(:user)

    sign_in(non_admin)
    visit(admin_payments_path)
    
    expect(page).to have_content("You do not have permission to do that")
    expect(page).not_to have_content("Bob Miller")
    expect(page).not_to have_content("bobmiller@example.com")
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("ch-123")  
  end
end