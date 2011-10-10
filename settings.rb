require 'json'

class Settings
  attr_accessor :post_dirs, :post_ext, :data_root, :qotd_paths
  attr_accessor :public_root, :base_url

  AzureRoot = File.dirname(__FILE__)
  DefaultPath = AzureRoot + '/settings.json'

  def initialize hash
    {
      'post-dirs' => :post_dirs=, 'post-ext' => :post_ext=,
      'data-root' => :data_root=, 'qotd-paths' => :qotd_paths=,
      'public-root' => :public_root=, 'base-url' => :base_url=
    }.each do |json_key, mutator|
      send mutator, (hash[json_key] || raise("Missing #{json_key} in settings.json"))
    end
  end

  def view_root
    AzureRoot + '/views'
  end

  def rss_path
    File.join(@public_root, 'feed.rss')
  end

  def rss_href
    url 'feed.rss'
  end

  # Convenience method to quickly generate URLs under the specified base.
  def url *parts
    (@base_url[-1] == '/' ? @base_url : @base_url + '/') + parts.join('/')
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
