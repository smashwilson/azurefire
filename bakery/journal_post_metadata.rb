require 'json'
require 'etc'

# A JournalPost's title, URL slug, timestamp, and other non-content data.
# Extracted from a JournalPost because many components (like the Baker, and
# the site archive) care only about metadata, and it's wasteful to shuffle
# around post content unnecessarily.
class JournalPostMetadata
  attr_accessor :title, :slug, :timestamp, :author, :tags

  include Comparable

  # JournalPosts naturally sort newest-first.
  def <=> other
    (timestamp <=> other.timestamp) * -1
  end

  # A diagnostic aid.
  def to_s
    "#{self.class}(#{slug})"
  end

  # Extract metadata from an opened File handle. Expects metadata to be present
  # in a JSON dictionary stored before the first double newline in the file
  # header. Missing metadata will be inferred from the file attributes when
  # possible: for example, the post author will be the file's owner, and so on.
  def self.load(file)
    header = file.gets("\n\n")
    data = JSON.parse(header)
    stat = File.stat(file.path)

    new.tap do |inst|
      inst.title = data['title'] || File.basename(file.path, '.md')
      inst.slug = data['slug'] || enslug(inst.title)
      inst.timestamp = if data['timestamp']
        Time.parse(data['timestamp'])
      else
        stat.mtime
      end
      inst.author = data['author'] || Etc.getpwuid(stat.uid)
      inst.tags = data['tags'] || []
    end
  end

  # Convert an arbitrary String into one that's safe for use within a URL, but
  # still readable.
  def self.enslug original
    ichs = '[^a-zA-Z0-9]'
    t = original.gsub(/^#{ichs}+/, '')
    t = t.gsub(/#{ichs}+$/, '')
    t = t.gsub(/[^a-zA-Z0-9]+/, '-')
    t.downcase
  end

end
