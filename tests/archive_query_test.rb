require 'tests/storage_test_case'

require 'model/archive_query'
require 'model/journal_post'

class ArchiveQueryTest < StorageTestCase
  
  def setup
    @all = []
    1.upto(50) do |index|
      p = JournalPost.new
      p.title = index.to_s.rjust(3, '0')
      p.save
      @all << p
    end
  end
  
  def test_default_to_all
    q = ArchiveQuery.new
    
    assert_equal 'all posts', q.to_s
    assert_equal @all, q.results
  end
  
end