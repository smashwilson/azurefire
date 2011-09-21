require 'time'
require 'fileutils'
require 'nokogiri'

require_relative 'storage_test_case'

require_relative '../model/journal_post'
require_relative '../model/journal_post_metadata'

class JournalPostTest < StorageTestCase

  def test_generate_path
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    path = JournalPost.path_for(meta)
    assert_equal(temp_path('posts/hello.html'), path)
  end

  def test_comment_path
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    comment_path = JournalPost.comment_path_for(meta)
    assert_equal(temp_path('comments/hello'), comment_path)
  end

  def test_create_from_meta
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    post = JournalPost.new(meta)
    assert_equal(temp_path('posts/hello.html'), post.path)
    assert(! post.baked?)

    FileUtils.mkdir_p(temp_path 'posts')
    File.open(temp_path('posts/hello.html'), 'w') do |f|
      f.puts "Expected post content"
    end

    assert(post.baked?)
    assert_equal("Expected post content\n", post.content)
  end

  def test_create_from_slug
    FileUtils.mkdir_p(temp_path 'posts')
    File.open(temp_path('posts/exists.html'), 'w') do |f|
      f.puts "Expected post content"
    end

    post = JournalPost.with_slug 'exists'
    assert_not_nil post
    assert_equal("Expected post content\n", post.content)
  end

  def test_detect_missing_slug
    missing = JournalPost.with_slug 'missing'
    assert missing.nil?
  end

  def test_enumerate_comments
    FileUtils.mkdir_p(temp_path 'posts')
    File.open(temp_path('posts/exists.html'), 'w') do |f|
      f.puts "Expected post content"
    end

    post = JournalPost.with_slug 'exists'
    [ 'one', 'two', 'three' ].each do |num|
      post.add_comment(Comment.new.tap do |c|
        c.name = num
        c.content = num + ' content'
      end)
    end

    cs = []
    post.each_rendered_comment { |c| cs << c }
    assert(cs[0].include? 'one content')
    assert(cs[1].include? 'two content')
    assert(cs[2].include? 'three content')
  end

end
