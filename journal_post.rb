require 'persistent'

class JournalPost < Persistent
  attr_accessor :title, :username, :timestamp, :body
  key :title
  key :username
  key(:timestamp) { |str| Time.at(str.to_i) }
  
end