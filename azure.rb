require 'sinatra'

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

# Keep debugging output nice and current in Eclipse.
$stdout.sync = true

before do
  # Configure site navigation.
  nav_item('news', :default => true) do
    nav_item 'latest', :default => true
    nav_item 'archive'
  end
  nav_item('about') do
    nav_item 'people', :default => true
    nav_item 'site'
  end
end

[ '/', '/news', '/news/latest' ].each do |route|
  get route do
    haml :latest
  end
end

get '/news/archive' do
  haml "<h1>news archive</h1>"
end

[ '/about', '/about/people' ].each do |route|
  get route do
    haml "<h1>about people</h1>"
  end
end

get '/about/site' do
  haml "<h1>about site</h1>"
end