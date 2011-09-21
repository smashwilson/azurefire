require 'forwardable'

require_relative '../settings'

require_relative 'journal_post_metadata'

class JournalPost
  extend Forwardable

  attr_reader :meta

  def_delegators :@meta, :title, :slug, :timestamp, :author, :tags

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

  def comment_count
    0
  end

  def comments
    []
  end

  def self.path_for meta
    Settings.data_path 'posts', "#{meta.slug}.html"
  end

  def self.comment_path_for meta
    Settings.data_path 'comments', meta.slug
  end

  def self.with_slug slug
    meta = JournalPostMetadata.new
    meta.slug = slug
    post = new(meta)
    post.baked? ? post : nil
  end

end
