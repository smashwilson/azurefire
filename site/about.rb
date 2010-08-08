# Routes and utilities for the /about section of the page.

[ '/about', '/about/people' ].each do |route|
  get route do
    haml "<p class='content' style='font-style: italic'>about people</p>"
  end
end

get '/about/site' do
  haml "<p class='content' style='font-style: italic'>about site</p>"
end