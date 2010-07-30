require 'test/unit'

require 'model/journal_post'

class JournalPostTest < Test::Unit::TestCase
  
  def setup
    super
    @db = Storage.new 'journal-post-test'
    @db.create
  end
  
  def test_user
    u = User.new
    
    p = JournalPost.new
    p.title = 'hooray'
    p.body = 'fun times'
    p.user = 
  end
  
  def teardown
    super
    @db.delete!
  end
end