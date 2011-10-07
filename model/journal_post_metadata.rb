require 'time'
require 'json'
require 'etc'

# An exception to raise if metadata is incomplete or malformed.
class MetadataError < StandardError
end

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
    basename = File.basename(file.path)
    header = file.gets("\n\n")
    begin
      data = JSON.parse(header)
    rescue JSON::ParserError
      raise MetadataError.new("Malformed JSON header in post \"#{basename}\".")
    end
    stat = File.stat(file.path)

    # Ensure that only valid keys are present in the JSON header.
    expected_keys = %w{title slug timestamp author tags}
    unrecognized = data.keys - expected_keys
    unless unrecognized.empty?
      keystr = if unrecognized.size == 1
        "key \"#{unrecognized[0]}\""
      else
        "keys " + unrecognized.map { |k| "\"#{k}\"" }.join(', ')
      end

      raise MetadataError.new("Unrecognized JSON header #{keystr} in post \"#{basename}\".")
    end

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
