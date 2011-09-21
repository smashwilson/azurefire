require_relative 'web_test_case'

require_relative '../bakery/baker'

class NewsTest < WebTestCase

  def fixture
    'fixtures/set'
  end

  def bake_posts
    Baker.new.bake!
  end

  def test_show_most_recent
    bake_posts

    get '/'
    ok!

    parse
    posts = @doc.css('div.post')

    exp_titles = ['Post 20', 'Post 19', 'Post 18', 'Post 17', 'Post 16']
    act_titles = posts.css('.header h2.title').map(&:content)
    assert_equal(exp_titles, act_titles)
  end

end
