require_relative 'post_index'

class ArchiveIndex < PostIndex

  def write_meta meta
    str = ""
    str << meta.timestamp.to_s << "\t"
    str << meta.tags.join(',') << "\t"
    str << meta.author << "\t"
    str << meta.slug << "\t"
    str << meta.title
    str
  end

end
