require 'yaml'

require 'storage'
require 'fileutils'

# Provide filesystem-based persistence with YAML.
class Persistent
  
  def initialize
    @persisted = false
  end
  
  def path
    "/#{directory}/#{key}.yaml"
  end
  
  def key
    send(self.class.key_accessor)
  end
  
  def directory
    self.class.default_directory or '.'
  end
  
  def save
    Storage.current.transaction do
      validate!
      unless @persisted || unique_key?
        invalid! "This #{self.class} already exists."
      end
      @persisted = true
      Storage.current.write(self, self.path)
    end
    self
  end
  
  def validate! ; end
  
  def invalid! message = "The #{self.class} cannot be saved."
    raise ValidationException.new(message)
  end
  
  def unique_key?
    not self.class.all_keys.include?(key)
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
    
    def all_files
      Dir[File.join(Storage.current.root, default_directory) + '/*.yaml']
    end
    
    def all_keys
      all_files.collect do |p|
        File.basename p, '.yaml'
      end
    end
    
    def all
      all_files.collect do |p|
        inst = YAML::load_file p
        yield inst if block_given?
        inst
      end
    end
    
    def find k = nil
      if block_given?
        all { |each| return each if yield each }
        nil
      else
        p = File.join(Storage.current.root, default_directory) + "/#{k}.yaml"
        return nil unless File.exist? p
        YAML::load_file p
      end
    end
    
  end
  
  class ValidationException < Exception ; end
  
end