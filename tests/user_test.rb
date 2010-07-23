require 'test/unit'

require 'user'

class UserTest < Test::Unit::TestCase
  
  def test_serialize
    u = User.new
    u.username = 'tester'
    u.password = 'ultrasecret'
    
    expected = <<ZZZ
password_hash: f99dcbb3dd40b1f3fa6ca2332fec02ff718a0502e6bb5b7ae78a6beb096c7806
ZZZ
    assert_equal expected, u.serialize
  end
  
  def test_deserialize
    source = <<ZZZ
password_hash: f99dcbb3dd40b1f3fa6ca2332fec02ff718a0502e6bb5b7ae78a6beb096c7806
ZZZ
    u = User.deserialize source
    
    assert_equal 'f99dcbb3', u.password_hash[0,8]
    assert u.has_password?('ultrasecret')
  end
  
end