require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack-flash'

require 'haml'
require 'sass'

require 'navigation'

helpers do
  include Navigation
end

# Run stylesheets through sass.
get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

before do
  # Configure site navigation.
  nav_item('news', '/news/latest') do
    nav_item 'latest', '/news/latest'
    nav_item 'archive', '/news/archive'
  end
  nav_item('about', '/about/people') do
    nav_item 'people', '/about/people'
    nav_item 'site', '/about/site'
  end
end

get '/' do
  haml :latest
end

get '/news/latest' do
  haml :latest
end

get '/news/archive' do
  haml "<h1>news archive</h1>"
end

get '/about' do
  haml "<h1>about people</h1>"
end

get '/about/site' do
  haml "<h1>about site</h1>"
end