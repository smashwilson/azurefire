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
    
    p.save @db
    
    np = JournalPost.find 'hooray', @db
    assert_equal p.title, np.title
    assert_equal p.body, np.body
    assert_equal p.user(@db), np.user
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
    p1.save @db
    
    p2 = JournalPost.new
    p2.title = 'some title'
    assert_raise(Persistent::ValidationException) { p2.save @db }
    
    p3 = JournalPost.new
    p3.title = 'some.  Title!'
    assert_raise(Persistent::ValidationException) { p3.save @db }
    
    assert_equal 1, JournalPost.all(@db).size
  end
  
end