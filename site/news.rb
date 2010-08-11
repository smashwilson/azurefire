# Routes and utilities for the /news section of the page.

require 'model/journal_post'
require 'model/draft'

[ '/', '/news', '/news/latest' ].each do |route|
  get route do
    @posts = JournalPost.latest
    haml :latest
  end
end

get '/news/archive' do
  haml '%p.empty news archive'
end

get '/news/write' do
  admin_only!
  @post = Draft.find(username) || Draft.new
  haml :news_write
end

get '/news/write/:year/:month/:day/:title' do |*args|
  admin_only!
  @post = JournalPost.find_url(*args)
  haml :news_write
end

post '/news/write' do
  admin_only!
  if params[:submit] == 'submit'
    p = JournalPost.from(username, params).save
    redirect "/news/write/#{p.url_slug}"
  else
    d = Draft.find(username) || Draft.new
    d.update username, params
    d.save
    redirect '/news/write'
  end
end