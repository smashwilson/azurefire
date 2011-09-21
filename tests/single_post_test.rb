require_relative 'web_test_case'

class SinglePostTest < WebTestCase

  def fixture
    'fixtures/set'
  end

  def bake_posts
    Baker.new.bake!
  end

  def test_show_body
    bake_posts
    get '/post-10'
    ok!

    assert(@doc.at_css('.markdown p').content.include? ' ten ')
  end

end
