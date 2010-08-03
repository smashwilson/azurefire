require 'fileutils'
require 'thread'

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
      unless persistent.persisted
        #
      end
      
      persistent.validate!(self)
      persistent.persisted = true
      
      full_path = File.join @root, path
      full_dir = File.dirname full_path
      FileUtils.mkdir_p full_dir unless File.exists?(full_dir)
      
      File.open(full_path, 'w') { |f| f << persistent.to_yaml }
    end
  end
  
  def create
    FileUtils.mkdir_p @root unless File.exists?(@root)
  end
  
  def delete!
    FileUtils.remove_entry_secure @root if File.directory?(@root)
  end
  
  def self.instance
    @@instance ||= new('./db')
  end
  
end