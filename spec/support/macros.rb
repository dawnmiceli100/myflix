def set_authenticated_user
  authenticated_user = Fabricate(:user)  
  session[:user_id] = authenticated_user.id 
end 

def set_admin_user(user=nil)
  admin_user = (user || set_authenticated_user)
  admin_user.admin = true
  admin_user.save
end  

def clear_authenticated_user
  session[:user_id] = nil
end 

def authenticated_user
  User.find(session[:user_id])
end  

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end 

def link_to_video(video)
  find("a[href='/videos/#{video.id}']").click
end  