require_relative 'web_test_case'

require_relative '../model/baker'

class NewsTest < WebTestCase

  def fixture
    'fixtures/set'
  end

  def setup
    super
    Baker.new.bake!
  end

  def test_show_most_recent
    get '/'
    ok!

    posts = @doc.css('div.post')

    exp_titles = ['Post 20', 'Post 19', 'Post 18', 'Post 17', 'Post 16']
    act_titles = posts.css('.header h2.title').map(&:content)
    assert_equal(exp_titles, act_titles)
  end

  def test_show_tags
    get '/'
    ok!

    tags = @doc.at_css('div.post').css('ul.tags a').map(&:content)
    assert_equal(%w{numbered multiple-of-five}, tags)
  end

  def test_show_qotd
    get '/'
    ok!

    qotd = @doc.at_css('div.qotd').content
    assert_match(/^This is the (first|second) quote in the quote file!$/, qotd)
  end

end
