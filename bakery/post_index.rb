require 'fileutils'

class PostIndex

  # Return the path of this Index within the filesystem, relative to the
  # data_root.
  def path
    raise '#path not overloaded'
  end

  def full_path
    File.join(Settings.current.data_root, path)
  end

  # Yield each JournalPostMetadata from @posts that should be included in this
  # index.
  def metas posts
    []
  end

  # Return a String representing this Index's entry for a provided journal
  # post.
  def write_meta meta
    raise '#write_meta not overloaded'
  end

  def create! posts
    FileUtils.mkdir_p(File.dirname(full_path))
    File.open(full_path, 'w') do |outf|
      metas(posts).each do |meta|
        outf.puts write_meta(meta)
      end
    end
  end

end
