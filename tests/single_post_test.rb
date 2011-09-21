require_relative 'web_test_case'

class SinglePostTest < WebTestCase

  def fixture
    'fixtures/set'
  end

  def setup
    super
    Baker.new.bake!
  end

  def test_show_body
    get '/post-10'
    ok!

    assert(@doc.at_css('.markdown p').content.include? ' ten ')
  end

  def test_post_comment
    assert(false, 'pending')
  end

end
