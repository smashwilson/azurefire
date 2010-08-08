# Site navigation.

require 'nav'

helpers do
  include NavigationHelper
end

before do
  nav 'news', :default => true do
    nav 'latest', :default => true
    nav 'archive'
  end
  nav 'about' do
    nav 'people', :default => true
    nav 'site'
  end
end