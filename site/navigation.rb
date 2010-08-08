# Site navigation.

require 'nav'

helpers do
  include NavigationHelper
end

before do
  nav 'news', :default => true do
    nav 'latest', :default => true
    nav 'archive'
    nav 'write', :admin => true
  end
  nav 'about' do
    nav 'people', :default => true
    nav 'site'
  end
  nav 'account', :admin => true do
    nav 'settings', :default => true
  end
end