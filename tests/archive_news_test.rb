require_relative 'web_test_case'
require_relative '../model/journal_post'

require 'time'

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
  
  def test_query_by_user
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
  
  def test_display_current_query
    get '/news/archive/foo'
    
    assert_css 'div.query p.current'
    assert_equal 'You are currently viewing posts by foo.', @node.content
  end
  
end