require 'tests/storage_test_case'

require 'model/user'

class UserTest < StorageTestCase
  
  def test_set_password
    u = User.new
    u.password = 'foo'
    assert u.has_password?('foo')
  end
  
  def test_roundtrip
    u1 = User.new
    u1.username = 'foo'
    u1.password = 'bar'
    
    u1.save @db
    assert_equal u1, User.find('foo', @db)
  end
  
  def test_unique_username
    u1 = User.new
    u1.username = 'foo'
    u1.save @db
    
    u2 = User.new
    u2.username = 'foo'
    assert_raise(Persistent::ValidationException) { u2.save @db }
  end
  
  def test_change_password
    u = User.new
    u.username = 'foo'
    u.password = 'bar'
    u.save @db
    
    u.password = 'hooray'
    u.save @db
    
    u = User.find 'foo', @db
    assert u.has_password?('hooray')
  end

end