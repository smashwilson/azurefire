require 'tests/web_test_case'

require 'model/journal_post'

class WriteNewsTest < WebTestCase
    
  def test_write_post
    login
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf'
    
    p = JournalPost.find { |each| each.title = 'hurf' }
    assert_equal 'foo', p.username
    assert_equal 'durf durf durf', p.body 
  end
  
  def test_disallow_anonymous_post
    post '/news/write', :title => 'hurf', :body => 'durf durf durf'
    assert last_response.not_found?
    
    assert_equal 0, JournalPost.all.size
  end
  
end