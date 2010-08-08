# Routes and utilities for the /news section of the page.

require 'model/journal_post'

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
  haml '%p.empty news write'
end