require 'tests/web_test_case'

require 'model/journal_post'
require 'model/draft'

require 'time'

class WriteNewsTest < WebTestCase
    
  def test_write_post
    login
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'Submit'
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
    
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'Preview'
    follow_redirect!
    
    assert_equal 0, JournalPost.all.size
    
    d = Draft.find 'foo'
    assert_equal 'hurf', d.title
    assert_equal 'durf durf durf', d.body
  end
  
  def test_begin_with_draft
    login
    
    d = Draft.new
    d.title = 'hurf'
    d.body = 'durf durf durf'
    d.username = 'foo'
    d.save
    
    get '/news/write'
    
    assert_css 'input.title'
    assert_equal 'hurf', @node['value']
    
    assert_css 'textarea'
    assert_equal 'durf durf durf', @node.content
  end
  
  def test_discard_draft_after_post
    login
    
    d = Draft.new
    d.title = 'hurf'
    d.body = 'durf durf durf'
    d.username = 'foo'
    d.save
    
    post '/news/write', :title => d.title, :body => d.body, :submit => 'Submit'
    follow_redirect!
    
    assert_equal 1, JournalPost.all.size
    assert_nil Draft.find('foo')
  end
  
  def test_render_preview
    login
    
    d = Draft.new
    d.title = 'hurf'
    d.body = 'durf durf *durf* durf'
    d.username = 'foo'
    d.save
    
    get '/news/write'
    
    assert_css '#preview .title'
    assert_equal 'hurf', @node.content
    
    assert_css '#preview p em'
    assert_equal 'durf', @node.content
  end
  
  def test_save_edited_post
    p = JournalPost.new
    p.title = 'Hurf! Hurf!'
    p.body = 'durf durf durf'
    p.timestamp = Time.parse('Aug 1 2010')
    p.save
    
    login
    post '/news/write', :title => p.title, :body => 'durfa durfa durf',
      :persisted => 'persisted', :timestamp => p.timestamp.to_i, :submit => 'Submit'
    follow_redirect!
    
    assert_equal 1, JournalPost.all.size
    saved = JournalPost.all.first
    assert_equal 'Hurf! Hurf!', saved.title
    assert_equal 'durfa durfa durf', saved.body
    assert_equal Time.parse('Aug 1 2010'), saved.timestamp
  end
  
  def test_disallow_anonymous_post
    post '/news/write', :title => 'hurf', :body => 'durf durf durf', :submit => 'Submit'
    assert last_response.not_found?
    
    assert_equal 0, JournalPost.all.size
  end
  
  def test_scrub_crlf
    post '/news/write', :title => 'hurf', :body => "durf\r\ndurf",
      :persisted => '', :timestamp => Time.now.to_i, :submit => 'Submit'
    follow_redirect!
    
    
  end
  
end