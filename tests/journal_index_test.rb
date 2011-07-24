require_relative '../model/journal_index'
require_relative 'storage_test_case'

class JournalIndexTest < StorageTestCase
  
  def setup
    @index = JournalIndex.new
    @index.sources << root
    @index.destination = create_temp
  end
  
  def test_scan_directory
    @index.scan
    assert_equal 3, @index.posts.size
    assert @index.posts.any? { |p| p.title == 'Metadata Madness' }
  end
  
  def test_render
    @index.scan
    @index.render!

    assert File.exist?(temp_path('metadata.html'))
    
    rendered = File.open(temp_path('metadata.html'), 'r') { |f| f.read nil}
    assert_equal <<CONTENT, rendered
<div class='post markdown'>
  <h2 class='title'>Metadata Madness</h2>
  <div class='metadata'>
    <span class='name'>Francis Archer Key</span>
    <span class='timestamp'>Saturday, 01 January 2011 08:00am</span>
  </div>
  <h1>This is the title</h1>
  
  <p>This is the content. Fear it.</p>
</div>
CONTENT
  end

end
