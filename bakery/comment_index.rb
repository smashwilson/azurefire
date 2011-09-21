require_relative '../settings'

class CommentIndex
  attr_accessor :post

  def initialize post
    @post = post
  end

  def path
    File.join(@post.comment_path, 'index')
  end

  def path_for hash
    File.join(@post.comment_path, "#{hash}.html")
  end

  def append comment
    File.open(path, 'a') do |f|
      f.puts comment.hash
    end
  end

  def each
    File.open(path, 'r') do |f|
      f.lines do |line|
        yield File.read(path_for line.chomp)
      end
    end
  end

end
