require 'json'
require 'pathname'

class Settings
  attr_reader :post_dirs, :post_ext, :data_root

  DefaultPath = Pathname.new(__FILE__).dirname + 'settings.json'

  def initialize hash
    @post_dirs = hash["post-dirs"] || ['.']
    @post_ext = hash["post-ext"] || '.md'
    @data_root = hash["data-root"] || raise('Missing data-root in settings.json')
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

end
