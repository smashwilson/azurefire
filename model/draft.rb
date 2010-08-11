require 'model/journal_post'

class Draft < JournalPost
  key :username
  directory 'draft'
  
  def as_post
    p = JournalPost.new
    [:title, :username, :timestamp, :body].each do |var|
      p.send("#{var}=", send(var))
    end
    p
  end
end