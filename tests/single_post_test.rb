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
    post '/post-10', { :name => 'someone', :body => "# heading\n\nbody"}
    follow_redirect!
    ok!

    assert_equal(2, @doc.css('ul.comments li').size)
    assert_equal('someone', @doc.at_css('ul.comments .name').content)
    assert_equal('heading', @doc.at_css('ul.comments .markdown h1').content)
    assert_equal('body', @doc.at_css('ul.comments .markdown p').content)
  end

end
