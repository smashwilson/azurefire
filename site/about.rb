# Routes and utilities for the /about section of the page.

[ '/about', '/about/people' ].each do |route|
  get route do
    haml '%p.empty about people'
  end
end

get '/about/site' do
  haml '%p.empty about site'
end