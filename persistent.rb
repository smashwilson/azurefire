require 'yaml'

require 'storage'
require 'fileutils'

# Provide filesystem-based persistence with YAML.
class Persistent
  attr_reader :persisted
  
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
    Storage.current.transaction do |s|
      validate!
      unless @persisted || unique_key?
        invalid! "This #{self.class} already exists."
      end
      @persisted = true
      s.write(self, self.path)
    end
    self
  end
  
  def update hash
    #
  end
  
  def delete!
    raise "Can't delete non-persisted object" unless @persisted
    Storage.current.transaction do |s|
      s.remove(self.path)
      @persisted = false
    end
  end
  
  def validate! ; end
  
  def invalid! message = "The #{self.class} cannot be saved."
    raise ValidationException.new(message)
  end
  
  def all_keys
    Storage.current.keys directory
  end
  
  def unique_key?
    not all_keys.include?(key)
  end
  
  class << self
    
    def from hash
      inst = new
      inst.update hash
      inst
    end
    
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
      Storage.current.files default_directory
    end
    
    def all_keys
      Storage.current.keys default_directory
    end
    
    def all
      all_files.collect do |p|
        inst = Storage.current.read p
        yield inst if block_given?
        inst
      end
    end
    
    def select
      results = []
      all { |each| results << each if yield each }
      results
    end
    
    def find k = nil
      if block_given?
        all { |each| return each if yield each }
        nil
      else
        Storage.current.read "#{default_directory}/#{k}.yaml"
      end
    end
    
    def clean_string string
      r = string.gsub /['".()\{\}\[\]]/, ''
      r = r.gsub /[^a-zA-Z0-9]+/, '_'
      r = r.gsub /^_+/, ''
      r = r.gsub /_+$/, ''
      r.downcase
    end
    
  end
  
  class ValidationException < StandardError ; end
  
end