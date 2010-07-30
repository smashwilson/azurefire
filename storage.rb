require 'fileutils'

class Storage
  attr_accessor :root, :mutex
  
  def initialize root
    @root = root
    @mutex = Mutex.new
  end
  
  def transaction
    @mutex.synchronize { yield }
  end
  
  def save persistent, path = persistent.path
    transaction do
      return unless persistent.validate?(self)
      
      full_path = File.join @root, path
      full_dir = File.dirname full_path
      FileUtils.mkdir_p full_dir unless Dir.exists?(full_dir)
      
      File.open(full_path, 'w') { |f| f << persistent.to_yaml }
    end
  end
  
  def create
    FileUtils.mkdir_p @root unless Dir.exists?(@root)
  end
  
  def delete!
    FileUtils.remove_entry_secure @root if Dir.exists?(@root)
  end
  
  def self.instance
    @@instance ||= new('./db')
  end
  
end