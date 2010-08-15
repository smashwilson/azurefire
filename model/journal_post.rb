require 'persistent'

require 'model/comment'

class JournalPost < Persistent
  directory 'post'
  
  attr_accessor :title, :username, :timestamp, :body
  key :file_slug
  
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
  
  def file_slug
    "#{@timestamp.strftime '%Y%m%d'}_#{clean_title}"
  end
  
  def url_slug
    [
      @timestamp.year.to_s.rjust(4, '0'),
      @timestamp.month.to_s.rjust(2, '0'),
      @timestamp.day.to_s.rjust(2, '0'),
      clean_title
    ].join '/'
  end
  
  def update hash
    @username = hash[:username]
    @title = hash[:title]
    @body = hash[:body]
  end
  
  def comments
    Comment.for_post self
  end
  
  # Find a JournalPost from the database based on information encoded in its #url_slug.
  def self.find_url year, month, day, title
    find "#{year.to_s.rjust(4, '0')}#{month.to_s.rjust(2, '0')}#{day.to_s.rjust(2, '0')}_#{title}"
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