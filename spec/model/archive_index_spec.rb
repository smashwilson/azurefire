require 'spec_helper'
require 'time'
require 'fileutils'

def create_fake_index
  FileUtils.mkdir_p(temp_path 'posts')

  %w{first third}.each do |name|
    File.open(temp_path('posts', "#{name}.html"), 'w') do |f|
      f.puts "2011-09-03 16:00:00 +0000\ttagone,tagtwo\tauthor\tthird\tThird"
      f.puts "2011-09-02 16:00:00 +0000\ttagone\tauthor\tsecond\tSecond"
      f.puts "2011-09-01 16:00:00 +0000\ttagtwo\tauthor\tfirst\tFirst"
    end
  end
end

describe ArchiveIndex do
  it 'creates an index entry' do
    meta = JournalPostMetadata.new
    meta.author = 'author'
    meta.timestamp = Time.parse('18 Sept 2011 4pm')
    meta.tags = %w{foo bar baz}
    meta.title = 'Title'
    meta.slug = 'title'

    i = ArchiveIndex.new
    entry = i.write_meta(meta)
    entry.should == "2011-09-18 16:00:00 +0000\tfoo,bar,baz\tauthor\ttitle\tTitle"
  end
end
