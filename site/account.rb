# Routes and utilities for manipulating user accounts.

require 'model/user'

helpers do
  def logged_in?
    session[:username]
  end
  
  def user
    @user ||= User.find(session[:username])
  end
  
  def welcome
    if logged_in?
      src = <<HML
%p
  Welcome, #{session[:username]}!
  %a{:href => '/account/logout'} Log out.
HML
    else
      src = <<HML
%p
  Welcome!  Please
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

get '/account/logout' do
  session[:username] = nil
  redirect '/'
end