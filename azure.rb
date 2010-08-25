# Master source file for the azurefire website.

require 'sinatra'

require 'haml'
require 'sass'
require 'bluecloth'

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
  c.also_reload 'model/*.rb'
end

helpers do
  # Safely convert user-entered +text+ into HTML with BlueCloth.
  def markdown text
    BlueCloth.new(text, :escape_html => true).to_html
  end
end

# Run stylesheets through sass.
get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

# Load the helpers used to define the site navigation.
require 'site/navigation'

# Load the site body.
require 'site/news'
require 'site/about'
require 'site/account'