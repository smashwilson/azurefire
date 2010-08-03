require 'test/unit'

require 'storage'

class StorageTestCase < Test::Unit::TestCase
  
  def setup
    @db = Storage.new(self.class.name.downcase)
    @db.create
  end
  
  def teardown
    @db.delete!
  end
  
end