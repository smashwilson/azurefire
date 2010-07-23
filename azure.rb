require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack-flash'

require 'haml'
require 'sass'

get %r{/([^.]+).css} do |name|
  content_type 'text/css', :charset => 'utf-8'
  sass name.to_sym
end

get '/' do
  haml :latest
end