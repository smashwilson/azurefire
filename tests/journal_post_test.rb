require 'tests/storage_test_case'
require 'time'

require 'model/journal_post'

class JournalPostTest < StorageTestCase
  
  def test_user
    u = User.new
    u.username = 'foo'
    u.password = 'bar'
    
    p = JournalPost.new
    p.title = 'hooray'
    p.body = 'fun times'
    p.user = u
    
    p.save
    
    np = JournalPost.find 'hooray'
    assert_equal p.title, np.title
    assert_equal p.body, np.body
    assert_equal p.user, np.user
    assert_equal p.timestamp, np.timestamp
  end
  
  def test_clean_title
    p = JournalPost.new
    p.title = 'hooray!  This title has + a bunch of 1234 stuff'
    
    assert_equal 'hooray_this_title_has_a_bunch_of_1234_stuff', p.clean_title
    
    p.title = "shouldn't this work too?!"
    assert_equal 'shouldnt_this_work_too', p.clean_title
    assert_equal p.clean_title, p.key
  end
  
  def test_validate_unique_clean_title
    p1 = JournalPost.new
    p1.title = 'some title'
    p1.save
    
    p2 = JournalPost.new
    p2.title = 'some title'
    assert_raise(Persistent::ValidationException) { p2.save }
    
    p3 = JournalPost.new
    p3.title = 'some.  Title!'
    assert_raise(Persistent::ValidationException) { p3.save }
    
    assert_equal 1, JournalPost.all.size
  end
  
  def test_latest
    u1 = User.new
    u1.username = 'a'
    
    u2 = User.new
    u2.username = 'b'
    
    p1 = JournalPost.new
    p1.title = 'one'
    p1.timestamp = Time.parse('7/1/2010')
    p1.user = u1
    p1.save
    
    p2 = JournalPost.new
    p2.title = 'two'
    p2.user = u2
    p2.timestamp = Time.parse('7/2/2010')
    p2.save
    
    p3 = JournalPost.new
    p3.title = 'three'
    p3.timestamp = Time.parse('7/3/2010')
    p3.user = u1
    p3.save
    
    p4 = JournalPost.new
    p4.title = 'four'
    p4.user = u2
    p4.timestamp = Time.parse('7/4/2010')
    p4.save
    
    assert_equal [p3, p4], JournalPost.latest
  end
  
end