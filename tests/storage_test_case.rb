require 'test/unit'
require 'fileutils'

class StorageTestCase < Test::Unit::TestCase

  def fixture ; 'fixtures' ; end

  def temporary ; 'temp' ; end

  def fixt_root
    File.join(File.dirname(__FILE__), fixture)
  end

  def temp_root
    File.join(File.dirname(__FILE__), temporary)
  end

  def fixt_path file
    "#{fixt_root}/#{file}"
  end

  def temp_path file
    "#{temp_root}/#{file}"
  end

  def create_temp
    Dir.mkdir(temp_root) && temp_root
  end

  def setup
    create_temp
    @settings = Settings.new({
      "post-dirs" => [fixt_root],
      "post-ext" => "md",
      "data-root" => temp_root
    })
  end

  def teardown
    FileUtils.rm_r(temp_root, :secure => true) if Dir.exists? temp_root
  end

end
