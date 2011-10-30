require 'fileutils'
require 'lockfile'

require_relative '../settings'
require_relative '../model/journal_post'
require_relative '../model/journal_post_metadata'

# A file-backed data structure that records metadata about journal posts, stored
# in order by their creation timestamp, newest first.
#
# This index is created by the Baker during rake processing.
class ArchiveIndex

  # Filesystem path at which the index data is stored, relative to the current
  # data root.
  def path
    File.join(Settings.current.data_root, 'posts', 'archive.index')
  end

  # Call with a block to ensure that only one process is altering this index.
  def lock
    FileUtils.mkdir_p(File.dirname(path))
    return yield if RUBY_PLATFORM =~ /w32$/
    Lockfile("#{path}.lock", :min_sleep => 0.1, :sleep_inc => 0.1) do
      yield
    end
  end

  # Encode JournalPostMetadata as a tab-delimited string.
  def write_meta meta
    str = ""
    str << meta.timestamp.to_s << "\t"
    str << meta.tags.join(',') << "\t"
    str << meta.author << "\t"
    str << meta.slug << "\t"
    str << meta.title
    str
  end

  # Decode a JournalPostMetadata from a tab-delimited string created with
  # #write_meta.
  def read_meta line
    meta = JournalPostMetadata.new
    timestamp_s, tags_s, meta.author, meta.slug, meta.title = *line.split("\t")
    meta.timestamp = Time.parse(timestamp_s)
    meta.tags = tags_s.split(",")
    meta
  end

  # Given a pre-sorted sequence of JournalPostMetadata instances, create a new
  # post index. Assumes that the posts are pre-sorted by the Baker so that
  # multiple indices can be generated without sorting the post collection more
  # than once.
  def create! posts
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') do |outf|
      posts.each do |meta|
        outf.puts write_meta(meta)
      end
    end
  end

  # Efficiently enumerate, in order, a sequence of JournalPostMetadata instances
  # created from an existing index file. The enumeration will be stop (with an
  # orderly close of the index file) if the associated block returns +:stop+.
  def each_post
    return [] unless File.exist?(path)
    File.open(path, 'r') do |f|
      each_post_from(f) { |post| yield post }
    end
  end

  # Return an Array containing metadata for the +count+ most recent posts.
  def recent_posts count
    recent = []
    each_post do |post|
      recent << post
      :stop if recent.size >= count
    end
    recent
  end

  # Return an Array containing metadata for posts that match an ArchiveQuery.
  def posts_matching query
    matches = []
    each_post do |post|
      matches << post if query.matches? post
    end
    matches
  end

  protected

  # Utility method extracted from #each_post so that the iteration can be
  # terminated prematurely without leaving the file handle open.
  def each_post_from f
    f.lines do |line|
      return if (yield JournalPost.new(read_meta line)) == :stop
    end
  end

end
