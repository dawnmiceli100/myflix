def set_authenticated_user
  authenticated_user = Fabricate(:user)  
  session[:user_id] = authenticated_user.id 
end 

def clear_authenticated_user
  session[:user_id] = nil
end 

def authenticated_user
  User.find(session[:user_id])
end  