# Master source file for the azurefire website.

require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require 'haml'
require 'sass'
require 'rdiscount'

configure :development do |c|
  require 'sinatra/reloader'
  c.also_reload 'settings.rb'
  c.also_reload 'nav.rb'
  c.also_reload 'honeypot.rb'
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
require_relative 'honeypot'

require_relative 'model/comment'
require_relative 'model/journal_post'
require_relative 'model/archive_index'
require_relative 'model/archive_query'
require_relative 'model/daily_quote'

# Site navigation and daily quote.

helpers do
  include NavigationHelper
  include Honeypot

  # Extracted to a method so it can be stubbed.
  def timestamp
    Time.now
  end

  # Choose which of the three honeypot fields to display this rendering. Always
  # include at least one.
  def choose_honeypots
    pots = (1..3).inject([]) do |chosen, current|
      if rand <= 0.5 then chosen << current else chosen end
    end
    pots << rand(3) + 1 if pots.empty?
    pots
  end
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

# Run stylesheets through scss.

get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  scss name.to_sym
end

# About page

get '/about' do
  haml :about
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
  @navigate_as = '/news'
  @post = JournalPost.with_slug slug
  halt 404 unless @post

  @next, @prev = @post.next, @post.prev
  @js = ['single-post']

  @ts = timestamp
  @spinner = spinner(@ts, request.ip, slug)

  # Generate the hashed field name and CSS class factor for the name field. The
  # name CSS class should be a multiple of 15.
  @name_field = field_name(@spinner, 'name')
  @name_css = "comment-#{15 * (rand(6) + 1)}"

  # Similarly generate the body factor. Body CSS classes are multiples of 13.
  @body_field = field_name(@spinner, 'body')
  @body_css = "comment-#{13 * (rand(7) + 1)}"

  # And the submit button. The submit button's CSS class is a multiple of 17.
  @submit_field = field_name(@spinner, 'submit')
  @submit_css = "comment-#{17 * (rand(5) + 1)}"

  # Generate names and classes for honeypot fields (multiple of 11), and
  # determine which honeypots will be visible this rendering.
  @honeypot_names = (1..3).map { |h| field_name(@spinner, "honeypot-#{h}") }
  @honeypot_css = @honeypot_names.map { |_| "comment-#{11 * (rand(9) + 1)}" }
  @honeypots_chosen = choose_honeypots

  haml :single_post
end

# Comment post

post '/:slug' do |slug|
  @post = JournalPost.with_slug slug
  halt 404 unless @post

  name, body = nil, nil

  # Detect the RSpec token. If it's present (and matches the application secret),
  # we're running in RSpec and can bypass spam detection.
  if params[:rspec_secret] == secret
    name, body = params[:name], params[:body]
  else
    # Extract the spinner and timestamp. Validate the them, then use them to
    # construct the expected field names.
    spinner = params[:spinner]
    ts_value = params[field_name(spinner, 'timestamp')]

    ts = Time.at(ts_value.to_i)
    diff = timestamp - ts
    halt 400 if diff < 0 || diff >= 14400 # In the future, or over four hours old

    expected_spinner = spinner(ts, request.ip, slug)
    halt 404 unless spinner == expected_spinner

    name_field = field_name(spinner, 'name')
    body_field = field_name(spinner, 'body')
    submit_field = field_name(spinner, 'submit')

    # Extract matching fields from the parameters. If any honeypot fields are
    # present, or if the submit field is missing, fail the POST.
    1.upto(3) do |honeypot|
      hn = field_name(spinner, "honeypot-#{honeypot}")
      halt 400 unless params[hn].nil? || params[hn].empty?
    end
    halt 400 unless params.has_key?(submit_field)

    name, body = params[name_field], params[body_field]
  end

  comment = Comment.new
  comment.name = name
  comment.content = body
  @post.add_comment comment
  redirect to("/#{slug}#comment-#{comment.number}")
end
