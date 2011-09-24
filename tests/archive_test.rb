require_relative 'web_test_case'

class ArchiveTest < WebTestCase

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

end
