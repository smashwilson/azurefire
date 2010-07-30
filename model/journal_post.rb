require 'persistent'

class JournalPost < Persistent
  attr_accessor :title, :username, :timestamp, :body
  
  def initialize
    super
    @timestamp = Time.now
  end
  
end