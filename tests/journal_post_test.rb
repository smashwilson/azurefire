require 'test/unit'
require 'time'
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

end
