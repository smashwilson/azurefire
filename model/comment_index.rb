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

  def path_for filename
    File.join(@post.comment_path, filename)
  end

  def append comment
    File.open(path, 'a') do |f|
      f.puts comment.filename
    end
  end

  def each
    File.open(path, 'r') do |f|
      f.lines do |line|
        cpath = path_for line.chomp
        yield File.read(cpath) if File.exist?(cpath)
      end
    end
  end

  # Return a one-up number for the next comment that is guaranteed to be unique within this directory.
  def unique_count
    cpath = path_for 'index.count'
    if File.exist?(cpath)
      ucount = File.read(cpath).chomp.to_i
    else
      ucount = 0
    end
    File.open(cpath, 'w') { |f| f.puts ucount + 1 }
    ucount
  end

  # Return the number of live comments. A comment is live if it would be rendered: it exists as a
  # real file in the directory, and it has an entry in the index.
  def live_count
    File.readlines(path).count { |f| File.exist?(path_for f.chomp) }
  end

end
