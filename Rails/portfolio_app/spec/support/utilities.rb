def valid_signin(user)
  fill_in 'Email',    with: user.email
  fill_in 'Password', with: user.password
  click_button 'Log in'
end

def sign_in(user)
  visit new_user_session_path
  valid_signin(user)
end
