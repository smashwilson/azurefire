require 'spec_helper'
require 'time'
require 'fileutils'

describe ArchiveIndex do
  it 'creates an index entry' do
    meta = JournalPostMetadata.new
    meta.author = 'author'
    meta.timestamp = Time.parse('18 Sept 2011 4pm')
    meta.tags = %w{foo bar baz}
    meta.title = 'Title'
    meta.slug = 'title'

    subject.write_meta(meta).should == "2011-09-18 16:00:00 +0000\tfoo,bar,baz\tauthor\ttitle\tTitle"
  end

  it 'indexes all journal posts' do
    meta0 = JournalPostMetadata.new
    meta0.author = 'author'
    meta0.timestamp = Time.parse('18 Sept 2011 4pm')
    meta0.tags = %w{foo bar baz}
    meta0.title = 'First'
    meta0.slug = 'first'

    meta1 = JournalPostMetadata.new
    meta1.author = 'author'
    meta1.timestamp = Time.parse('19 Sept 2011 4pm')
    meta1.tags = %w{foo thing}
    meta1.title = 'Second'
    meta1.slug = 'second'

    subject.create! [meta0, meta1].sort

    lines = File.read(temp_path 'posts', 'archive.index').split("\n")
    lines[0].should == "2011-09-19 16:00:00 +0000\tfoo,thing\tauthor\tsecond\tSecond"
    lines[1].should == "2011-09-18 16:00:00 +0000\tfoo,bar,baz\tauthor\tfirst\tFirst"
  end

  context 'with a fake index' do
    before do
      FileUtils.mkdir_p(temp_path 'posts')

      [ "first", "third" ].each do |name|
        File.open(temp_path("posts/#{name}.html"), 'w') do |f|
          f.print "#{name} content"
        end
      end

      File.open(temp_path('posts/archive.index'), 'w') do |f|
        f.puts "2011-09-03 16:00:00 +0000\ttagone,tagtwo\tauthor\tthird\tThird"
        f.puts "2011-09-02 16:00:00 +0000\ttagone\tauthor\tsecond\tSecond"
        f.puts "2011-09-01 16:00:00 +0000\ttagtwo\tauthor\tfirst\tFirst"
      end
    end

    it 'enumerates indexed content' do
      ps = []
      subject.each_post { |p| ps << p }
      ps.map(&:slug).should == %w{third second first}
    end

    it 'supports partial enumeration' do
      ps = []
      subject.each_post do |post|
        ps << post
        :stop if post.slug == 'second'
      end
      ps.map(&:slug).should == %w{third second}
    end

    it 'fetches recent posts' do
      subject.recent_posts(2).map(&:slug).should == %w{third second}
    end

    it 'supports archive queries' do
      q = ArchiveQuery.new 'tagtwo'
      ps = subject.posts_matching(q)
      ps.map(&:slug).should == %w{third first}

      q = ArchiveQuery.new 'tagone'
      ps = subject.posts_matching(q)
      ps.map(&:slug).should == %w{third second}
    end
  end
end
