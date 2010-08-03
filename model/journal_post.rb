require 'persistent'

class JournalPost < Persistent
  directory 'post'
  
  attr_accessor :title, :username, :timestamp, :body
  key :clean_title
  
  def initialize
    super
    @timestamp = Time.now
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
  
end