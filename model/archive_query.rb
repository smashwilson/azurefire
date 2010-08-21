require 'model/journal_post'

class ArchiveQuery
  
  def to_s
    'all posts'
  end
  
  def results
    JournalPost.all
  end
  
end