require 'time'
require 'fileutils'

require_relative '../bakery/archive_index'
require_relative '../model/journal_post_metadata'

require_relative 'storage_test_case'

class ArchiveIndexTest < StorageTestCase

  def create_fake_index
    FileUtils.mkdir_p(temp_path 'posts')

    [ "first", "third" ].each do |name|
      File.open(temp_path("posts/#{name}.html"), 'w') do |f|
        f.print "#{name} content"
      end
    end

    File.open(temp_path('posts/archive.index'), 'w') do |f|
      f.puts "2011-09-03 16:00:00 -0400\ttag\tauthor\tthird\tThird"
      f.puts "2011-09-02 16:00:00 -0400\ttag\tauthor\tsecond\tSecond"
      f.puts "2011-09-01 16:00:00 -0400\ttag\tauthor\tfirst\tFirst"
    end
  end

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

  def test_enumerate_content
    create_fake_index

    i = ArchiveIndex.new

    ps = []
    i.each_post { |p| ps << p }
    assert_equal(['third', 'second', 'first'], ps.map(&:slug))
  end

  def test_partial_enumeration
    create_fake_index

    i = ArchiveIndex.new
    ps = []
    i.each_post do |post|
      ps << post
      :stop if post.slug == 'second'
    end
    assert_equal(['third', 'second'], ps.map(&:slug))
  end

  def test_recent_posts
    create_fake_index

    i = ArchiveIndex.new
    ps = i.recent_posts(2)
    assert_equal(['third', 'second'], ps.map(&:slug))
  end

end
