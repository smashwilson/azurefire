require 'yaml'

require 'storage'
require 'fileutils'

# Provide filesystem-based persistence with YAML.
class Persistent
  
  def path
    "/#{directory}/#{key}.yaml"
  end
  
  def key
    "instance"
  end
  
  def directory
    self.class.default_directory or '.'
  end
  
  def save store = Storage.instance
    store.save self
  end
  
  def validate? store
    true
  end
  
  class << self  
    
    def default_directory
      @directory
    end
    
    def directory path
      @directory = path
    end
    
    def all store = Storage.instance
      Dir[File.join(store.root, default_directory) + '/*.yaml'].collect do |path|
        yield YAML::load_file(path)
      end
    end
    
    def find k = nil, store = Storage.instance
      if k.nil?
        all(store) { |each| return each if yield each }
      else
        p = File.join(store.root, default_directory) + "/#{k}.yaml"
        return nil unless File.exist? p
        YAML::load_file p
      end
    end
    
  end
  
end