require_relative '../settings'

class CommentIndex
  attr_accessor :post

  def initialize post
    @post = post
  end

  def path
    File.join(@post.comment_path, 'index')
  end

  def append comment
    File.open(path, 'a') do |f|
      f.puts comment.hash
    end
  end

end
