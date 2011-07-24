require 'test/unit'
require 'fileutils'

class StorageTestCase < Test::Unit::TestCase
  
  def fixture ; 'fixtures' ; end
  
  def temporary ; 'temp' ; end
  
  def root
    File.join(File.dirname(__FILE__), fixture)
  end
  
  def temp
    File.join(File.dirname(__FILE__), temporary)
  end
  
  def path file
    "#{root}/#{file}"
  end
  
  def temp_path file
    "#{temp}/#{file}"
  end
  
  def create_temp
    Dir.mkdir(temp) && temp
  end
  
  def teardown
    FileUtils.rm_r(temp, :secure => true) if Dir.exists? temp
  end
  
end
