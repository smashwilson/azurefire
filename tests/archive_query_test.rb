require 'test/unit'

require_relative '../model/archive_query'
require_relative '../model/journal_post_metadata'

class ArchiveQueryTest < Test::Unit::TestCase

  def posts
    1.upto(20).map do |i|
      meta = JournalPostMetadata.new
      meta.title = i.to_s
      meta.slug = i.to_s
      meta.tags = ['numbered']
      meta.tags << 'even' if i % 2 == 0
      meta.tags << 'odd' if i % 2 == 1
      meta.tags << 'multiple-of-five' if i % 5 == 0
      meta
    end
  end

  def test_query_by_all
    q = ArchiveQuery.new ''
    assert(posts.all? { |p| q.matches? p })
  end

  def test_single_tag
    q = ArchiveQuery.new 'multiple-of-five'
    ms = posts.select { |p| q.matches? p }.map { |p| p.title }
    expected = %w{5 10 15 20}
    assert_equal expected, ms
  end

  def test_multiple_tags
    q = ArchiveQuery.new 'multiple-of-five_even'
    ms = posts.select { |p| q.matches? p }.map { |p| p.title }
    expected = %w(2 4 5 6 8 10 12 14 15 16 18 20)
    assert_equal expected, ms
  end

end
