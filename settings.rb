require 'json'

class Settings
  attr_reader :post_dirs, :post_ext, :data_root

  AzureRoot = File.dirname(__FILE__)
  DefaultPath = AzureRoot + '/settings.json'

  def initialize hash
    @post_dirs = hash["post-dirs"] || ['.']
    @post_ext = hash["post-ext"] || '.md'
    @data_root = hash["data-root"] || raise('Missing data-root in settings.json')
  end

  def view_root
    AzureRoot + '/views'
  end

  def self.load string
    new(JSON.parse(string))
  end

  def self.current= settings
    Thread.current[:settings] = settings
  end

  def self.current
    Thread.current[:settings] ||= load(File.read(DefaultPath))
  end

  # Convenience method to quickly generate paths under the data root.
  def self.data_path *paths
    File.join(current.data_root, *paths)
  end

end
