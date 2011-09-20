# Routes and utilities for the /news section of the page.

require_relative '../model/journal_post'

[ '/', '/news', '/news/latest' ].each do |route|
  get route do
    @posts = JournalPost.latest
    haml :news_latest
  end
end

get %r{/news/archive(/([^/]+))?} do |_, query|
  halt 404, 'pending!'
end

# Comment post
post '/news/:year/:month/:day/:title' do |*args|
  halt 404, 'pending!'
end
