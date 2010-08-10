require 'tests/web_test_case'

require 'model/journal_post'

class WriteNewsTest < WebTestCase
    
  def test_write_post
    login
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf'
    
    p = JournalPost.find { |each| each.title = 'hurf' }
    assert_equals 'foo', p.username
    assert_equals 'durf durf durf', p.body 
  end
  
end