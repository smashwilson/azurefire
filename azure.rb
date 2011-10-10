# Master source file for the azurefire website.

require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require 'haml'
require 'sass'
require 'rdiscount'

configure :development do |c|
  require 'sinatra/reloader'
  c.also_reload 'model/*.rb'

  # Keep debugging output nice and current in Eclipse.
  $stdout.sync = true
end

configure :test do |c|
  # Don't produce log messages among that nice row of "rake test" dots.
  c.disable :logging
end

# Load required source files.

require_relative 'nav'
require_relative 'model/comment'
require_relative 'model/journal_post'
require_relative 'model/archive_index'
require_relative 'model/archive_query'
require_relative 'model/daily_quote'

# Site navigation and daily quote.

helpers do
  include NavigationHelper
end

before do
  @quote = DailyQuote.choose

  menu do
    nav 'news', :default => true
    nav 'archive'
    nav 'about'
  end
end

not_found { haml :'404' }

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
    @posts = ArchiveIndex.new.recent_posts(5)
    haml :news
  end
end

# Archive page

get %r{/archive(/([^/]+))?} do |_, query|
  i = ArchiveIndex.new
  @query = ArchiveQuery.new(query)
  @posts = i.posts_matching @query
  haml :archive
end

# Live markdown preview
post '/markdown-preview' do
  RDiscount.new(params[:body], :filter_html).to_html
end

# News post permalink
get '/:slug' do |slug|
  @post = JournalPost.with_slug slug
  halt 404 unless @post
  @next, @prev = @post.next, @post.prev
  @js = ['single-post']
  haml :single_post
end

# Comment post

post '/:slug' do |slug|
  @post = JournalPost.with_slug slug
  halt 404 unless @post
  comment = Comment.new
  comment.name = params[:name]
  comment.content = params[:body]
  @post.add_comment comment
  redirect to("/#{slug}")
end
