require 'fileutils'

class ArchiveIndex

  def path
    File.join(Settings.current.data_root, 'posts/archive.index')
  end

  def write_meta meta
    str = ""
    str << meta.timestamp.to_s << "\t"
    str << meta.tags.join(',') << "\t"
    str << meta.author << "\t"
    str << meta.slug << "\t"
    str << meta.title
    str
  end

  def read_meta line
    meta = JournalPostMetadata.new
    timestamp_s, tags_s, meta.author, meta.slug, meta.title = *line.split("\t")
    meta.timestamp = Time.parse(timestamp_s)
    meta.tags = tags_s.split(",")
    meta
  end

  def create! posts
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') do |outf|
      posts.each do |meta|
        outf.puts write_meta(meta)
      end
    end
  end

  def each_post
    return [] unless File.exist?(path)
    File.open(path, 'r') do |f|
      each_post_from(f) { |post| yield post }
    end
  end

  protected

  def each_post_from f
    f.lines do |line|
      return if (yield JournalPost.new(read_meta line)) == :stop
    end
  end

end
