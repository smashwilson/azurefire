require 'tests/web_test_case'

require 'model/journal_post'
require 'model/draft'

class WriteNewsTest < WebTestCase
    
  def test_write_post
    login
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'submit'
    follow_redirect!
    
    p = JournalPost.find { |each| each.title = 'hurf' }
    assert_equal 'foo', p.username
    assert_equal 'durf durf durf', p.body
    
    assert_css 'input.title'
    assert_equal 'hurf', @node['value']
    assert_css 'textarea'
    assert_equal 'durf durf durf', @node.content
  end
  
  def test_save_draft
    login
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'preview'
    follow_redirect!
    
    assert_equal 0, JournalPost.all.size
    
    d = Draft.find 'foo'
    assert_equal 'hurf', d.title
    assert_equal 'durf durf durf', d.body
  end
  
  def test_disallow_anonymous_post
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'submit'
    assert last_response.not_found?
    
    assert_equal 0, JournalPost.all.size
  end
  
end