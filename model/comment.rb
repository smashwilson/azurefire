require 'persistent'

class Comment < Persistent
  attr_accessor :name, :body, :timestamp, :administrator, :journal_post_key
  directory 'comments'
  key :microseconds
  
  include Comparable
  
  def initialize
    super
    @timestamp = Time.now
    @name = ''
    @administrator = false
  end
  
  def update hash
    @name = hash[:name]
    @body = hash[:body]
  end
  
  def directory
    "comments/#{@journal_post_key}"
  end
  
  def microseconds
    "#{@timestamp.to_i}-#{@timestamp.usec}"
  end
  
  def <=> other
    self.timestamp <=> other.timestamp
  end
  
  def journal_post= post
    @journal_post_key = post.key
  end
  
  class << self
  
    def files_for_post post
      Storage.current.files("comments/#{post.key}")
    end
  
    def all_for_post post
      files_for_post(post).collect do |fname|
        Storage.current.read fname
      end.sort
    end
  
  end
  
end