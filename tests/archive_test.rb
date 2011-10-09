require_relative 'web_test_case'

class ArchiveTest < WebTestCase

  # Posts numbered 1 to 20; posts 5, 10, 15, and 20 are tagged "multiple-of-five";
  # posts numbered 3, 7 and 15 are tagged "special".
  def fixture
    'fixtures/set'
  end

  def setup
    super
    Baker.new.bake!
  end

  def test_show_posts
    get '/archive'
    ok!

    results = @doc.css('ul.results > li')
    assert_equal(20, results.size)

    top = results[0]
    assert_equal('Tue 20 Sep 2011  8:00am', top.at_css('span.timestamp').content)
    assert_equal('Post 20', top.at_css('a').content)

    second = results[1]
    assert_equal('Mon 19 Sep 2011  8:00am', second.at_css('span.timestamp').content)
    assert_equal('Post 19', second.at_css('a').content)
  end

  def test_query_by_tag
    get '/archive/special_multiple-of-five'
    ok!

    results = @doc.css('ul.results > li')
    assert_equal(6, results.size)

    expected = [20, 15, 10, 7, 5, 3].map { |n| "Post #{n}" }
    titles = results.map { |r| r.at_css('a').content }
    assert_equal(expected, titles)
  end

  def test_show_empty_query
    get '/archive'
    ok!

    q = @doc.at_css('.query p.current').content
    assert_equal('You are currently viewing all posts.', q)
  end

  def test_show_single_query
    get '/archive/special'
    ok!

    q = @doc.at_css('.query p.current').content
    assert_equal('You are currently viewing posts tagged special.', q)
  end

  def test_show_multiple_query
    get '/archive/special_multiple-of-five'
    ok!

    q = @doc.at_css('.query p.current').content
    assert_equal('You are currently viewing posts tagged special or multiple-of-five.', q)
  end

end
