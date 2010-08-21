require 'model/journal_post'

class ArchiveQuery
  attr_accessor :terms
  
  def initialize
    @terms = []
  end
  
  def to_s
    return 'all posts' if @terms.empty?
    
    phrases = @terms.collect { |term| "<strong>#{term}</strong>" }
    user_phrase = phrases.join ' or '
    "posts by #{user_phrase}"
  end
  
  def results
    JournalPost.select { |post| matches? post }
  end
  
  def matches? post
    @terms.empty? or @terms.any? { |term| post.username == term }
  end
  
  # Parse a Query object from a user-provided query string.
  def self.from string
    inst = self.new
    inst.terms += string.split(/_+/)
    inst
  end
  
end