# Routes and utilities for the /news section of the page.

require 'model/journal_post'
require 'model/draft'
require 'model/archive_query'

[ '/', '/news', '/news/latest' ].each do |route|
  get route do
    @posts = JournalPost.latest
    haml :news_latest
  end
end

get %r{/news/archive(/([^/]+))?} do |_, query|
  @query = ArchiveQuery.from query
  @results = @query.results
  haml :news_archive
end

get '/news/write' do
  admin_only!
  @post = Draft.find(username) || Draft.new
  haml :news_write
end

get '/news/edit/:year/:month/:day/:title' do |*args|
  admin_only!
  @post = JournalPost.find_url(*args)
  haml :news_write
end

post '/news/write' do
  admin_only!
  params[:username] = username
  
  d = Draft.find(username) || Draft.new
  d.update params
  d.save
  
  if params[:submit] == 'Submit'
    if params[:persisted] == 'value'
      ts = Time.at(params[:timestamp].to_i)
      clean_title = Persistent.clean_string params[:title]
      p = JournalPost.find_url ts.year, ts.month, ts.day, clean_title
      halt 404 if p.nil?
    else
      p = JournalPost.new
    end
    p.update params
    begin
      p.save
    rescue Persistent::ValidationException => e
      flash[:error] = "Oh, shit! #{e.to_s}"
      redirect '/news/write'
    end
    
    d.delete!
    
    flash[:success] = 'The post has been saved.'
    redirect "/news/edit/#{p.url_slug}"
  else
    redirect '/news/write'
  end
end

get '/news/:year/:month/:day/:title' do |*args|
  @post = JournalPost.find_url(*args)
  halt 404 unless @post
  haml :news_post
end

# Comment post
post '/news/:year/:month/:day/:title' do |*args|
  @post = JournalPost.find_url(*args)
  halt 404 unless @post
  comment = Comment.from params
  comment.journal_post = @post
  if logged_in?
    comment.administrator = true
    comment.name = username
  end
  comment.save
  redirect "/news/#{args.join '/'}"
end