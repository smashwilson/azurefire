require_relative 'web_test_case'

class SinglePostTest < WebTestCase

  def fixture
    'fixtures/set'
  end

  def setup
    super
    Baker.new.bake!
  end

  def test_unrecognized_post
    get '/nonsense'
    assert_equal(404, last_response.status)
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

  def test_post_comment_to_missing_post
    post '/huuurf', { :name => 'me', :body => 'in your face!'}
    assert_equal(404, last_response.status)
  end

  def test_show_comment_count
    post '/post-10', { :name => 'first', :body => 'First comment'}
    follow_redirect!

    post '/post-10', { :name => 'second', :body => 'Second comment'}
    follow_redirect!

    post '/post-10', { :name => 'third', :body => 'Third comment'}
    follow_redirect!

    ok!

    assert_equal('comments (3)', @doc.at_css('li.comment-count').content.strip)
  end

  def test_live_preview
    post '/markdown-preview', { :body => '# heading line' }
    ok!

    assert_equal('<h1>heading line</h1>', last_response.body.chomp)
  end

  def test_generate_next_prev
    get '/post-10'
    ok!

    nlink = @doc.at_css('a.next')
    assert_equal('/post-11', nlink['href'])
    assert_equal('Post 11', nlink.content)

    plink = @doc.at_css('a.prev')
    assert_equal('/post-9', plink['href'])
    assert_equal('Post 9', plink.content)
  end

  def test_nav_news_active
    get '/post-10'
    ok!

    news_nav = @doc.at_css('ul.navigation li a.current')
    assert_equal('news', news_nav.content)
  end

end
