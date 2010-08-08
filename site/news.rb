# Routes and utilities for the /news section of the page.

require 'model/journal_post'

[ '/', '/news', '/news/latest' ].each do |route|
  get route do
    @posts = JournalPost.latest
    haml :latest
  end
end

get '/news/archive' do
  haml "<p class='content' style='font-style: italic'>news archive</p>"
end