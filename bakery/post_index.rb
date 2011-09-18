class PostIndex

  def initialize posts
    @posts = posts
  end

  # Return the path of this Index within the filesystem, relative to the
  # data_root.
  def path
    raise '#path not overloaded'
  end

  # Yield each JournalPostMetadata from @posts that should be included in this
  # index.
  def metas
  end

  # Return a String representing this Index's entry for a provided journal
  # post.
  def write_meta meta
    meta.slug
  end

  def create!
    File.open(File.join(Settings.current.data_root, path), 'w') do |outf|
      metas do |meta|
        outf.puts write_meta(meta)
      end
    end
  end

end
