require_relative 'storage_test_case'

require_relative '../bakery/journal_post_metadata'
require_relative '../bakery/frontpage_index'

class FrontpageIndexTest < StorageTestCase

  def test_index_entry
    meta = JournalPostMetadata.new
    meta.slug = 'foo'
    meta.timestamp = Time.parse('Sept 17 2011 8am')

    i = FrontpageIndex.new
    entry = i.write_meta(meta)
    assert_equal('foo', entry)
  end

  def test_index_count
    metas = 1.upto(10).map do |i|
      meta = JournalPostMetadata.new
      meta.slug = i.to_s
      meta.timestamp = Time.parse("Sept #{i} 2011 8am")
      meta
    end

    i = FrontpageIndex.new
    i.count = 3
    i.create! metas

    lines = File.read(temp_path 'posts/frontpage.index').split("\n")
    assert_equal("10", lines[0])
    assert_equal("9", lines[1])
    assert_equal("8", lines[2])
    assert_equal(3, lines.size)
  end

end
