require 'time'
require 'nokogiri'

require_relative 'storage_test_case'
require_relative '../model/baker'
require_relative '../model/comment'
require_relative '../model/journal_post'

class BakerTest < StorageTestCase

  def test_bake_post
    b = Baker.new
    meta = b.bake_post(fixt_path 'sample.md')

    assert_equal('sample', meta.author)
    assert_equal('Sample Post', meta.title)
    assert_equal('sample-post', meta.slug)
    assert_equal(Time.parse('8am 17 Sept 2011'), meta.timestamp)
    assert_equal(['sample', 'lorem'], meta.tags)

    assert File.exist?(temp_path 'posts/sample-post.html')

    doc = Nokogiri::XML(File.read(temp_path 'posts/sample-post.html'))
    assert_equal('sample', doc.at_css('.header span.author').content)
    assert_equal('Sat 17 Sep 2011  8:00am', doc.at_css('.header span.timestamp').content)
    assert_equal('Sample Post', doc.at_css('.header h2.title').content)

    assert File.exist?(temp_path 'comments/sample-post/index')
    assert_equal('', File.read(temp_path 'comments/sample-post/index'))
  end

  def test_disallow_route
    b = Baker.new
    meta = b.bake_post(fixt_path 'route-collision.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_match(/route-collision\.md\.err$/, b.errors[0].filename)
    assert_equal('Post title "news" collides with an existing route', b.errors[0].reason)
  end

  def test_invalid_json
    b = Baker.new
    meta = b.bake_post(fixt_path 'invalid-json.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_equal('Malformed JSON header in post "invalid-json.md.err".', b.errors[0].reason)
  end

  def test_unrecognized_json_key
    b = Baker.new
    meta = b.bake_post(fixt_path 'extra-json-key.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_equal('Unrecognized JSON header key "tiiiiitle" in post "extra-json-key.md.err".', b.errors[0].reason)
  end

  def test_duplicate_slug
    b = Baker.new
    b.bake_post(fixt_path 'sample.md')
    meta = b.bake_post(fixt_path 'sample-duplicate.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_equal('Post path "sample-post" is duplicated in "sample.md" and "sample-duplicate.md.err".', b.errors[0].reason)
  end

  def test_invalid_tags
    b = Baker.new
    meta = b.bake_post(fixt_path 'invalid-tag-characters.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_equal('Invalid character in tags of post "invalid-tag-characters.md.err".', b.errors[0].reason)
  end

  def test_bake
    b = Baker.new

    b.bake! do |progress|
      case progress.meta.slug
      when 'sample-post'
        assert_equal(3, progress.total)
        assert_equal(0, progress.errors)
        assert_not_nil(progress.meta)
      when 'other-post'
        assert_equal(3, progress.total)
        assert_equal(0, progress.errors)
        assert_not_nil(progress.meta)
      when 'third-post'
        assert_equal(3, progress.total)
        assert_equal(0, progress.errors)
        assert_not_nil(progress.meta)
      end
    end

    assert File.exist?(temp_path 'posts/sample-post.html')
    assert_equal "other-post\tOther Post", File.read(temp_path 'posts/next/sample-post')
    assert File.exist?(temp_path 'comments/sample-post/index')

    assert File.exist?(temp_path 'posts/other-post.html')
    assert_equal "sample-post\tSample Post", File.read(temp_path 'posts/prev/other-post')
    assert_equal "third-post\tThird Post", File.read(temp_path 'posts/next/other-post')
    assert File.exist?(temp_path 'comments/other-post/index')

    assert File.exist?(temp_path 'posts/third-post.html')
    assert_equal "other-post\tOther Post", File.read(temp_path 'posts/prev/third-post')
    assert File.exist?(temp_path 'comments/third-post/index')

    assert File.exist?(temp_path 'posts/archive.index')

    assert File.exist?(public_path 'feed.rss')
  end

  def test_bake_comment
    b = Baker.new

    meta = b.bake_post(fixt_path 'sample.md')
    post = JournalPost.new(meta)

    comment0 = Comment.new
    comment0.name = 'foo'
    comment0.content = 'Expected comment content'

    b.bake_comment! post, comment0

    comment_file = temp_path "comments/sample-post/#{comment0.hash}.html"
    assert File.exist?(comment_file)
    comment_doc = Nokogiri::HTML(File.read(comment_file))
    assert_equal('foo', comment_doc.at_css('p.name').content)
    assert_equal('Expected comment content', comment_doc.at_css('.markdown p').content)

    comment1 = Comment.new
    comment1.name = 'other'
    comment1.content = 'Another expected comment'

    b.bake_comment! post, comment1

    index_file = temp_path "comments/sample-post/index"
    assert File.exist?(index_file)
    entries = File.read(index_file).split("\n")
    assert_equal([comment0.hash, comment1.hash], entries)
  end

end
