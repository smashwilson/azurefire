require 'test/unit'

class StorageTestCase < Test::Unit::TestCase

  def fixture ; 'fixtures' ; end

  def root
    File.join(File.dirname(__FILE__), fixture)
  end
  
  def path file
    "#{root}/#{file}"
  end

end