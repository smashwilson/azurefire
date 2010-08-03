require 'persistent'

class JournalPost < Persistent
  directory 'post'
  
  attr_accessor :title, :username, :timestamp, :body
  key :clean_title
  
  def initialize
    super
    @timestamp = Time.now
  end
  
  def == other
    other.title == @title
  end
  
  def user= u
    @username = u.username
  end
  
  def user
    User.find @username
  end
  
  def clean_title
    clean_string title
  end
  
  # Return a collection of the latest-timestamped JournalPosts for each User.
  # Operates in a single pass through the directory.
  def self.latest
    results = {}
    all do |post|
      current = results[post.username]
      if current.nil? || post.timestamp > current.timestamp
        results[post.username] = post
      end
    end
    results.values.shuffle
  end
  
end