require 'test/unit'
require 'time'

require_relative '../model/journal_post'
require_relative 'storage_test_case'

class JournalPostTest < StorageTestCase
  
  def test_bake
    post = JournalPost.from(path 'unadorned.md')
    assert_equal "<p>Data data data</p>\n", post.body
  end
  
  def test_apply_markdown
    post = JournalPost.from(path 'markdown.md')
    assert_equal <<CONTENT, post.body
<h1>Thing</h1>

<p><strong>strong</strong> <em>emphasis</em></p>
CONTENT
  end
  
  def test_extract_metadata
    post = JournalPost.from(path 'metadata.md')
    assert_equal 'metadata', post.filename
    assert_equal 'Metadata Madness', post.title
    assert_equal 'Francis Archer Key', post.username
    assert_equal (Time.parse '2011-01-01 08:00'), post.timestamp
  end
  
end
