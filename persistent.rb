require 'stringio'

# Provide filesystem-based persistence.
class Persistent
  
  # Serialize to a String (probably for testing).
  def serialize
    stream = StringIO.new
    serialize_to stream
    stream.string
  end
  
  # Serialize this instance to +stream+.
  def serialize_to stream
    self.class.key_array.each do |ka|
      stream.puts "#{ka.name}: #{send(ka.name)}"
    end
  end
  
  class << self
    
    # An internal class used to store information about serialization keys
    # and their corresponding deserialization blocks.
    class KeyAssignment
      attr_accessor :name, :callback
      
      def initialize name, callback
        @name, @callback = name, callback
      end
    end
    
    # Lazily initialize the array of known KeyAssignments.
    def key_array
      @key_array ||= []
    end
    
    # Add a key to the list of things that will be serialized in the key-value
    # header.  If a callback is provided, it will be used to convert the
    # native String value into an object during deserialization.  If no callback
    # is provided, the string will be set directly.
    def key name, &callback
      key_array << KeyAssignment.new(name, callback || (Proc.new() { |a| a }))
    end
    
    # A shortcut for quickly defining a set of key names at once.
    def keys *names
      names.each { |n| key n }
    end
    
    def deserialize_from stream
      inst = new
      until (line = stream.gets).nil? or line.empty?
        puts line
        unless (md = line.strip.match(/([^:]+):\W*(.*)$/)).nil?
          ka = key_array.detect { |k| k.name.to_s == md[1] }
          inst.send "#{ka.name}=".to_sym, ka.callback.call(md[2])
        end
      end
      inst
    end
    
    def deserialize string
      deserialize_from(StringIO.new string)
    end
    
  end
  
end