# Master source file for the azurefire website.

require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require 'haml'
require 'sass'
require 'rdiscount'

require 'rack-flash'

# Use encrypted cookie-based session handling.
use Rack::Session::Cookie,
  :key => 'azure.session',
  :path => '/',
  :expire_after => 86400, # 1 day
  :secret => '2c26-b46b68Qfc68ff99'

use Rack::Flash

# Keep debugging output nice and current in Eclipse.
$stdout.sync = true

configure :development do |c|
  require 'sinatra/reloader'
  c.also_reload 'bakery/*.rb'
  c.also_reload 'model/*.rb'
end

# Site nagivation.
require_relative 'nav'

helpers do
  include NavigationHelper
end

before do
  nav 'news', :default => true
  nav 'archive'
  nav 'about'
end

# Run stylesheets through sass.
get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

# About page
get '/about' do
  haml '%p.empty about page'
end

# News page
[ '/', '/news' ].each do |route|
  get route do
    halt 404, 'pending!'
  end
end

get %r{/archive(/([^/]+))?} do |_, query|
  halt 404, 'pending!'
end

# News post permalink
get '/:slug' do |slug|
  halt 404, 'pending!'
end

# Comment post
post '/:slug' do |slug|
  halt 404, 'pending!'
end
