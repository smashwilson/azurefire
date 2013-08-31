require 'fileutils'

# Helpers for specs that manipulate actual file storage.
module StorageHelpers
  # Common paths.

  def fixt_root
    File.join(__dir__, '..', 'fixtures')
  end

  def temp_root
    File.join(__dir__, '..', '..', 'tmp')
  end

  def public_root
    File.join(temp_root, 'public')
  end

  # Path generation helpers

  def fixt_path *paths
    File.join(fixt_root, *paths)
  end

  def temp_path *paths
    File.join(temp_root, *paths)
  end

  def public_path *paths
    File.join(public_path, *paths)
  end

  def qotd_path
    File.join(__dir__, '..', 'fixtures', 'fake-quotes.qotd')
  end

  # Temporary storage filesystem manipulation.

  def clear_temp!
    FileUtils.rm_r(temp_root, secure: true) if Dir.exists? temp_root
  end

  def create_temp!
    clear_temp!
    FileUtils.mkdir_p(temp_root)
    FileUtils.mkdir_p(public_root)
  end

  # Initialize test storage.
  def setup_storage
    create_temp!
    Settings.current = Settings.new(
      'post-dirs' => [fixt_root],
      'post-ext' => 'md',
      'data-root' => temp_root,
      'public-root' => public_root,
      'base-url' => 'http://example.com/',
      'qotd-paths' => [qotd_path]
    )
  end

  # Destroy test storage.
  def teardown_storage
    clear_temp! if ENV['KEEP_STORAGE'].nil?
  end
end
