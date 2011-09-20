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

  def create! posts
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') do |outf|
      posts.each do |meta|
        outf.puts write_meta(meta)
      end
    end
  end

end
