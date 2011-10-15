require 'lockfile'

require_relative '../settings'

class CommentIndex
  attr_accessor :post

  def initialize post
    @post = post
  end

  def path
    File.join(@post.comment_path, 'index')
  end

  def lock
    return yield if RUBY_PLATFORM =~ /w32$/
    Lockfile("#{path}.lock", :min_sleep => 0.1, :sleep_inc => 0.1) do
      yield
    end
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

  def size
    File.readlines(path).size
  end

end
