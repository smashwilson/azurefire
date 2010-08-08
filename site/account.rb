# Routes and utilities for manipulating user accounts.

require 'model/user'

helpers do
  # Return true if there's a User logged in, false if there isn't.
  def logged_in?
    session[:username]
  end
  
  # Render a 404 response if no user is logged in.
  def admin_only!
    halt 404 unless logged_in?
  end
  
  # Render the text and link for the global layout's "user display" section.
  def welcome
    if logged_in?
      src = <<HML
%p
  Welcome, #{session[:username]}.
  %a{:href => '/account/logout'} Log out.
HML
    else
      src = <<HML
%p
  Welcome. Please
  %a{:href => '/account/login'} Log in.
HML
    end
    haml src, :layout => false
  end
end

get '/account/login' do
  @failed = params[:failed] == 'true'
  haml :login
end

post '/account/login' do
  u = User.find params[:username]
  if u && u.has_password?(params[:password])
    session[:username] = u.username
    redirect '/'
  else
    redirect '/account/login?failed=true'
  end
end

['/account', '/account/settings'].each do |route|
  get route do
    haml '%p.empty account settings'
  end
end

get '/account/logout' do
  session[:username] = nil
  redirect '/'
end