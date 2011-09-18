require 'time'

require_relative 'storage_test_case'

require_relative '../bakery/archive_index'
require_relative '../bakery/journal_post_metadata'

class ArchiveIndexTest < StorageTestCase

  def test_index_entry
    meta = JournalPostMetadata.new
    meta.author = 'author'
    meta.timestamp = Time.parse('18 Sept 2011 4pm')
    meta.tags = ['foo', 'bar', 'baz']
    meta.title = 'Title'
    meta.slug = 'title'

    i = ArchiveIndex.new []
    entry = i.write_meta(meta)
    assert_equal("2011-09-18 16:00:00 -0400\tfoo,bar,baz\tauthor\ttitle\tTitle", entry)
  end

end
