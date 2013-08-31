require 'spec_helper'

require 'time'
require 'fileutils'
require 'nokogiri'

describe JournalPost do
  it 'generates its storage path' do
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    JournalPost.path_for(meta).should == temp_path('posts', 'hello.html')
  end

  it 'generates its comment path' do
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    JournalPost.comment_path_for(meta).should == temp_path('comments', 'hello')
  end

  it 'can be created from metadata' do
    meta = JournalPostMetadata.new
    meta.slug = 'hello'

    post = JournalPost.new(meta)
    post.path.should == temp_path('posts', 'hello.html')
    post.should_not be_baked

    FileUtils.mkdir_p(temp_path 'posts')
    File.open(temp_path('posts/hello.html'), 'w') do |f|
      f.puts "Expected post content"
    end

    post.should be_baked
    post.content.should == "Expected post content\n"
  end

  it 'can be created from a slug' do
    FileUtils.mkdir_p(temp_path 'posts')
    File.open(temp_path('posts', 'exists.html'), 'w') do |f|
      f.puts "Expected post content"
    end

    post = JournalPost.with_slug 'exists'
    post.should_not be_nil
    post.content.should == "Expected post content\n"
  end

  it 'detects missing slugs' do
    JournalPost.with_slug('missing').should be_nil
  end

  context 'with comments' do
    let(:post) { JournalPost.with_slug 'exists' }

    before do
      FileUtils.mkdir_p(temp_path 'posts')
      File.open(temp_path('posts', 'exists.html'), 'w') do |f|
        f.puts "Expected post content"
      end
      FileUtils.mkdir_p(temp_path 'comments', 'exists')
      File.open(temp_path('comments', 'exists', 'index'), 'w') { |f| }

      %w{one two three}.each do |num|
        c = Comment.new
        c.name = num
        c.content = num + ' content'
        post.add_comment c
      end
    end

    it 'enumerates its comments' do
      cs = []
      post.each_rendered_comment { |c| cs << c }
      cs[0].should =~ /one content/
      cs[1].should =~ /two content/
      cs[2].should =~ /three content/
    end

    it 'counts its comments' do
      post.comment_count.should == 3
    end
  end
end
