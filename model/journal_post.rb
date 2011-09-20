require_relative '../bakery/journal_post_metadata'
require_relative '../settings'

class JournalPost
  attr_reader :meta

  def initialize meta = JournalPostMetadata.new
    @meta = meta
  end

  def path
    self.class.path_for(@meta)
  end

  def baked?
    File.exist?(path)
  end

  def content
    File.read(path)
  end

  def self.path_for meta
    Settings.data_path 'posts', "#{meta.slug}.html"
  end

  def self.comment_path_for meta
    Settings.data_path 'comments', meta.slug
  end

end
