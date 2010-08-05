require 'sinatra'

require 'haml'
require 'sass'
require 'bluecloth'

require 'navigation'
require 'model/journal_post'

configure :production do
  Storage.use 'db'
end

configure :development do
  Storage.use 'dev-db'
end

helpers do
  include Navigation
  
  def markdown text
    BlueCloth.new(text, :escape_html => true).to_html
  end
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
    @posts = JournalPost.latest
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