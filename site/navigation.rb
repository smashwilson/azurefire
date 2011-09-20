# Site navigation.

require_relative '../nav'

helpers do
  include NavigationHelper
end

before do
  nav 'news', :default => true
  nav 'archive'
  nav 'about'
end
