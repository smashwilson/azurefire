require 'yaml'

require 'storage'
require 'fileutils'

# Provide filesystem-based persistence with YAML.
class Persistent
  attr_accessor :persisted
  
  def path
    "/#{directory}/#{key}.yaml"
  end
  
  def key
    send(self.class.key_accessor)
  end
  
  def directory
    self.class.default_directory or '.'
  end
  
  def save store = Storage.instance
    store.transaction do
      validate!
      store.write self
    end
  end
  
  def validate! store ; end
  
  def invalid! message = "The #{self.class} cannot be saved."
    raise ValidationException.new(message)
  end
  
  def unique_key_in! store
    if self.class.all_keys(store)
  end
  
  def clean_string string
    r = string.gsub /['".()\{\}\[\]]/, ''
    r = r.gsub /[^a-zA-Z0-9]+/, '_'
    r = r.gsub /^_+/, ''
    r = r.gsub /_+$/, ''
    r.downcase
  end
  
  class << self
    
    def key_accessor
      @key_accessor
    end
    
    def key symbol
      @key_accessor = symbol
    end
    
    def default_directory
      @directory
    end
    
    def directory path
      @directory = path
    end
    
    def all_files store = Storage.instance
      Dir[File.join(store.root, default_directory) + '/*.yaml']
    end
    
    def all_keys store = Storage.instance
      all_files(store).collect do |path|
        File.basename path, '.yaml'
      end
    end
    
    def all store = Storage.instance
      all_files(store).collect do |path|
        inst = YAML::load_file path
        yield inst if block_given?
        inst
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
  
  class ValidationException < Exception ; end
  
end