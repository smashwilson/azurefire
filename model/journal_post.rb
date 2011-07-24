require 'rdiscount'
require 'json'

require_relative '../persistent'
require_relative 'comment'

class JournalPost < Persistent
  attr_accessor :title, :username, :filename, :timestamp, :body
  
  def == other
    other.url_slug == url_slug
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
    @timestamp = hash[:timestamp]
    @filename = hash[:filename]
  end
  
  def <=> other
   (@timestamp <=> other.timestamp) * -1
  end
  
  def self.from path
    metadata = {}
    content = File.open(path, 'r') do |f|
      owner_info = Etc.getpwuid(f.stat.uid)
      metadata[:username] = owner_info ? owner_info.name : 'unknown'
      metadata[:timestamp] = f.ctime
      metadata[:filename] = File.basename(f.path, '.md')
      f.read nil
    end
    
    md = content.match(/\n\n/)
    if md && md.pre_match.strip[0] == "{"
      raw_metadata = md.pre_match
      raw_body = md.post_match
    else
      raw_metadata = '{}'
      raw_body = content
    end
    
    metadata[:body] = RDiscount.new(raw_body).to_html
    
    JSON.parse(raw_metadata).each_pair do |key, value|
      case key
      when 'timestamp'
        metadata[:timestamp] = Time.parse value
      else
        metadata[key.to_sym] = value
      end
    end
    
    inst = new
    inst.update(metadata)
    inst
  end
  
  # Return a collection of the latest-timestamped JournalPosts.
  def self.latest
    []
  end
  
end
