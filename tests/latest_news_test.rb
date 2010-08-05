require 'tests/web_test_case'

class LatestNewsTest < WebTestCase
  
  def test_default_navigation
    ['/', '/news', '/news/latest'].each do |link|
      get link
      
      assert_css 'ul.main-navigation li a.current'
      assert_equal '/news', @node['href']
      
      assert_css 'ul.sub-navigation li a.current'
      assert_equal '/news/latest', @node['href']
    end
  end
  
  def test_render_post
    p1 = JournalPost.new
    p1.title = 'First title'
    p1.body = 'things'
    p1.save
    
    get '/news/latest'
    
    assert_css '.post h2.title'
    assert_equal 'First title', @node.content
    
    assert_css '.post p'
    assert_equal 'things', @node.content
  end
  
end