require 'test/unit'

require 'storage'
require 'model/user'

class UserTest < Test::Unit::TestCase
  
  def setup
    super
    @db = Storage.new 'usertest'
    @db.create
  end
  
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
  
  def teardown
    super
    @db.delete!
  end
end