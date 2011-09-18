require 'time'
require 'nokogiri'

require_relative 'storage_test_case'
require_relative '../bakery/baker'

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
  end

  def test_disallow_route
    b = Baker.new
    meta = b.bake_post(fixt_path 'route-collision.md.err')

    assert_nil meta
    assert_equal(1, b.errors.size)
    assert_equal('news', b.errors[0].meta.slug)
    assert_equal('Post title "news" collides with an existing route', b.errors[0].reason)
  end

end
