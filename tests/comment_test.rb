require_relative 'storage_test_case'

require_relative '../model/comment'
require_relative '../model/journal_post'

class CommentTest < StorageTestCase
  
  def test_create_comment
    p = JournalPost.new
    p.title = 'hurf'
    p.timestamp = Time.parse('Aug 1, 2010 4am')
    
    c = Comment.new
    c.name = 'mr. foo'
    c.body = 'durf durf durf'
    c.timestamp = Time.at(12345)
    c.journal_post = p
    
    assert_equal '12345-0', c.key
    assert_equal '/comments/20100801_hurf/12345-0.yaml', c.path
  end
  
  def test_find_by_post
    p = JournalPost.new
    p.title = 'hurf'
    p.timestamp = Time.parse('Jan 1, 2010')
    
    10.times do
      c = Comment.new
      c.body = 'comment'
      c.journal_post = p
      c.save
    end
    
    rs = Comment.all_for_post(p)
    assert_equal 10, rs.size
    assert(rs.all? { |each| each.body == 'comment'})
  end
  
end