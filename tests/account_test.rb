require 'tests/web_test_case'

class AccountTest < WebTestCase
  
  def setup
    super
    
    u = User.new
    u.username = 'foo'
    u.password = 'foo'
    u.save
  end
  
  def test_welcome_text
    get '/'
        
    assert_css '.user-display p a'
    assert_equal '/account/login', @node['href']
    
    post '/account/login', :username => 'foo', :password => 'foo'
    follow_redirect!
    assert last_request.url !~ /failed=true/
        
    assert_css '.user-display p a'
    assert_equal '/account/logout', @node['href']
    
    assert_css '.user-display p'
    assert @node.content =~ /foo/
  end
  
  def invalid_login username, password
    get '/'
    
    post '/account/login', :username => username, :password => password
    follow_redirect!
    
    assert_css '.error'
    assert last_request.url =~ /failed=true/
  end
  
  def test_wrong_password
    invalid_login 'foo', 'blargh'
  end
  
  def test_wrong_username
    invalid_login 'blargh', 'blargh'
  end
  
end