require 'yaml'

require 'fileutils'
require 'pathname'
require 'thread'

class Storage
  attr_accessor :root, :mutex
  
  def initialize root
    @root = root
    @mutex = Mutex.new
  end
  
  def transaction
    @mutex.synchronize { yield self }
  end
  
  def full_path_of partial
    Pathname.new(File.join(@root, partial.split('/')))
  end
  
  def read path
    full = full_path_of path
    return nil unless full.readable?
    YAML::load_file full
  end
  
  def write persistent, path
    full = full_path_of path
    full_dir = full.dirname
    
    full_dir.mkpath unless full_dir.exist?
    full.open('w') { |f| f << persistent.to_yaml }
  end
  
  def files dir
    full = full_path_of dir
    return [] unless full.directory?
    full.children.select { |p| p.file? && p.extname == '.yaml' }.collect do |p|
      p.relative_path_from(Pathname.new @root).to_s
    end
  end
  
  def keys dir
    files(dir).collect { |fname| File.basename fname, '.yaml' }
  end
  
  def remove path
    File.delete(full_path_of path)
  end
  
  def create!
    transaction do
      FileUtils.mkdir_p @root unless File.exists?(@root)
    end
  end
  
  def delete!
    transaction do
      FileUtils.remove_entry_secure @root if File.directory?(@root)
    end
  end
  
  def self.use root
    @current = new root
  end
  
  def self.current
    @current or use(ENV['RACK_ENV'] == :production ? 'db' : 'dev-db')
  end
  
end