require 'time'
require 'nokogiri'

require_relative 'storage_test_case'
require_relative '../bakery/baker'

class BakerTest < StorageTestCase

  def test_bake_post
    b = Baker.new @settings
    meta = b.bake_post(fixt_path 'sample.md')

    assert_equal('sample', meta.author)
    assert_equal('Sample Post', meta.title)
    assert_equal('sample-post', meta.slug)
    assert_equal(Time.parse('8am 17 Sept 2011'), meta.timestamp)
    assert_equal(['sample', 'lorem'], meta.tags)

    assert File.exist?(temp_path 'posts/sample-post.html')
  end

end
