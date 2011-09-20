require 'time'
require 'fileutils'
require 'nokogiri'

require_relative '../model/journal_post'
require_relative '../bakery/journal_post_metadata'
require_relative 'storage_test_case'

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

end
