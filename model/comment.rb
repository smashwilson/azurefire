require 'digest/sha2'

class Comment
  attr_accessor :name, :content

  def hash
    Digest::SHA256.hexdigest(@content)
  end
end
