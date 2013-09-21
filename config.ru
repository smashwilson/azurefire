require 'sinatra'
require 'sass/plugin/rack'

require File.join(File.dirname(__FILE__), 'azure.rb')

Sass::Plugin.options.tap do |sass|
  sass[:template_location] = 'views'
  sass[:css_location] = 'public'
end

use Sass::Plugin::Rack
run Sinatra::Application
