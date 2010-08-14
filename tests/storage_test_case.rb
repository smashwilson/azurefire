require 'test/unit'

require 'storage'

class StorageTestCase < Test::Unit::TestCase
  
  def setup
    Storage.use self.class.name.downcase
    Storage.current.create!
  end
  
  def teardown
    Storage.current.delete!
  end
  
end