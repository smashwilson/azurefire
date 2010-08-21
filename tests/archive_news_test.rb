require 'tests/web_test_case'

require 'time'

require 'model/journal_post'

class ArchiveNewsTest < WebTestCase
  
  def test_list_all
    1.upto 30 do |i|
      p = JournalPost.new
      p.title = 'post'
      p.timestamp = Time.parse "Aug #{i} 2010 10am"
      p.save
    end
    
    get '/news/archive'
    
    parse
    assert_equal 30, @doc.css('ul.results li').size
  end
  
  def test_search_by_user
    1.upto 30 do |i|
      p = JournalPost.new
      p.title = "post #{i}"
      p.username = i.odd? ? 'foo' : 'other'
      p.save
    end
    
    get '/news/archive/foo'
    
    parse
    assert_equal 15, @doc.css('ul.results li').size
    assert @doc.css('ul.results li span.name').all? { |n| n.content == 'foo' }
  end
  
end