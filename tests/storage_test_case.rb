require 'test/unit'
require 'fileutils'

class StorageTestCase < Test::Unit::TestCase

  def fixture ; 'fixtures' ; end

  def temporary ; 'temp' ; end

  def public ; 'temp/public' ; end

  def fixt_root
    File.join(File.dirname(__FILE__), fixture)
  end

  def temp_root
    File.join(File.dirname(__FILE__), temporary)
  end

  def public_root
    File.join(File.dirname(__FILE__), public)
  end

  def fixt_path file
    "#{fixt_root}/#{file}"
  end

  def temp_path file
    "#{temp_root}/#{file}"
  end

  def public_path file
    "#{public_root}/#{file}"
  end

  def create_temp
    teardown
    FileUtils.mkdir_p(temp_root)
    FileUtils.mkdir_p(public_root)
  end

  def setup
    create_temp
    Settings.current = Settings.new({
      "post-dirs" => [fixt_root],
      "post-ext" => "md",
      "data-root" => temp_root,
      "public-root" => public_root,
      "base-url" => 'http://example.com/',
      "qotd-paths" => [File.join(File.dirname(__FILE__), 'fixtures/fake-quotes.qotd')]
    })
  end

  def teardown
    FileUtils.rm_r(temp_root, secure: true) if Dir.exists? temp_root
  end

end
