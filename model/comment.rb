require 'digest/sha2'

class Comment
  attr_accessor :name, :content, :number

  def filename
    number.to_s.rjust(4, "0") + ".html"
  end

end
