require 'persistent'

class Comment < Persistent
  attr_accessor :name, :body, :timestamp, :administrator, :journal_post_key
  directory 'comments'
  key :microseconds
  
  def initialize
    super
    @timestamp = Time.now
    @name = ''
    @administrator = false
  end
  
  def directory
    "comments/#{@journal_post_key}"
  end
  
  def microseconds
    "#{@timestamp.to_i}-#{@timestamp.usec}"
  end
  
  def journal_post= post
    @journal_post_key = post.key
  end
  
  def self.for_post post
    Storage.current.files("comments/#{post.key}").collect do |fname|
      Storage.current.read fname
    end
  end
  
end