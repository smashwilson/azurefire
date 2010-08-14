require 'tests/web_test_case'

require 'model/journal_post'

class PostNewsTest < WebTestCase
  
  def test_single_post_view
    p = JournalPost.new
    p.title = 'hurf'
    p.body = 'durf durf durf'
    p.timestamp = Time.parse 'Aug 1, 2010 10am'
    p.save
    
    get '/news/2010/08/01/hurf'
    assert last_response.ok?
    
    assert_css '.post h2.title'
    assert_equal 'hurf', @node.content
    
    assert_css '.post p'
    assert_equal 'durf durf durf', @node.content
  end
  
  def test_missing_post
    get '/news/2000/10/01/blah'
    assert last_response.not_found?
  end
  
end