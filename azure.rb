# Master source file for the azurefire website.

require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require 'haml'
require 'sass'
require 'rdiscount'

require 'rack-flash'

# Use encrypted cookie-based session handling.
use Rack::Session::Cookie,
  :key => 'azure.session',
  :path => '/',
  :expire_after => 86400, # 1 day
  :secret => '2c26-b46b68Qfc68ff99'

use Rack::Flash

# Keep debugging output nice and current in Eclipse.
$stdout.sync = true

configure :development do |c|
  require 'sinatra/reloader'
  c.also_reload 'bakery/*.rb'
  c.also_reload 'model/*.rb'
end

# Run stylesheets through sass.
get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

# Load the helpers used to define the site navigation.
require_relative 'site/navigation'

# Load the site body.
require_relative 'site/about'
require_relative 'site/news'
