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

    i = ArchiveIndex.new
    entry = i.write_meta(meta)
    assert_equal("2011-09-18 16:00:00 -0400\tfoo,bar,baz\tauthor\ttitle\tTitle", entry)
  end

  def test_index_all
    meta0 = JournalPostMetadata.new
    meta0.author = 'author'
    meta0.timestamp = Time.parse('18 Sept 2011 4pm')
    meta0.tags = ['foo', 'bar', 'baz']
    meta0.title = 'First'
    meta0.slug = 'first'

    meta1 = JournalPostMetadata.new
    meta1.author = 'author'
    meta1.timestamp = Time.parse('19 Sept 2011 4pm')
    meta1.tags = ['foo', 'thing']
    meta1.title = 'Second'
    meta1.slug = 'second'

    i = ArchiveIndex.new
    i.create! [meta0, meta1].sort

    lines = File.read(temp_path 'posts/archive.index').split("\n")
    assert_equal("2011-09-19 16:00:00 -0400\tfoo,thing\tauthor\tsecond\tSecond", lines[0])
    assert_equal("2011-09-18 16:00:00 -0400\tfoo,bar,baz\tauthor\tfirst\tFirst", lines[1])
  end

end
