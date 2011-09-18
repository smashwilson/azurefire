require 'json'
require 'etc'

class JournalPostMetadata
  attr_accessor :title, :slug, :timestamp, :author, :tags

  include Comparable

  def <=> other
    (timestamp <=> other) * -1
  end

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

  def self.enslug original
    ichs = '[^a-zA-Z0-9]'
    t = original.gsub(/^#{ichs}+/, '')
    t = t.gsub(/#{ichs}+$/, '')
    t = t.gsub(/[^a-zA-Z0-9]+/, '-')
    t.downcase
  end

end
