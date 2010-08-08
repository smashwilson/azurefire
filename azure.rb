# Master source file for the azurefire website.

require 'sinatra'

require 'haml'
require 'sass'
require 'bluecloth'

# Keep debugging output nice and current in Eclipse.
$stdout.sync = true

helpers do
  def markdown text
    BlueCloth.new(text, :escape_html => true).to_html
  end
end

# Run stylesheets through sass.
get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

# Load the site body.
require 'site/navigation'
require 'site/news'
require 'site/about'