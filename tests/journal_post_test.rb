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
    
    np = JournalPost.find { |each| each.title = 'hooray' }
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
  end
  
  def test_generate_key
    p = JournalPost.new
    p.title = 'A title that, needs cleaning!'
    p.timestamp = Time.parse('Aug 1, 2010 4:32am')
    
    assert_equal '20100801_a_title_that_needs_cleaning', p.key
  end
  
  def test_validate_uniqueness
    t = Time.now
    
    p1 = JournalPost.new
    p1.title = 'some title'
    p1.timestamp = t
    p1.save
    
    p2 = JournalPost.new
    p2.title = 'some title'
    p2.timestamp = t
    assert_raise(Persistent::ValidationException) { p2.save }
    
    p3 = JournalPost.new
    p3.title = 'some.  Title!'
    p3.timestamp = t
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
    
    latest = JournalPost.latest
    assert_equal 2, latest.size
    assert latest.include?(p3)
    assert latest.include?(p4)
  end
  
  def test_generate_url
    p = JournalPost.new
    p.title = 'foo! bar, baz.'
    p.timestamp = Time.parse('Aug 1, 2010 3:14am')
    
    assert_equal '2010/08/01/foo_bar_baz', p.url_slug
  end
  
  def test_find_by_url
    p = JournalPost.new
    p.title = 'something else'
    p.timestamp = Time.parse('Feb 1, 2011 3pm')
    p.save
    
    f = JournalPost.find_url('2011', '2', '1', 'something_else')
    assert_equal p.title, f.title
  end
  
end