require 'spec_helper'

describe ArchiveQuery do
  let(:posts) do
    1.upto(20).map do |i|
      meta = JournalPostMetadata.new
      meta.title = i.to_s
      meta.slug = i.to_s
      meta.tags = ['numbered']
      meta.tags << 'even' if i % 2 == 0
      meta.tags << 'odd' if i % 2 == 1
      meta.tags << 'multiple-of-five' if i % 5 == 0
      meta
    end 
  end

  it 'queries all posts by default' do
    q = ArchiveQuery.new ''
    posts.each { |p| q.matches?(p).should == true }
  end

  it 'queries a single tag' do
    q = ArchiveQuery.new 'multiple-of-five'
    ms = posts.select { |p| q.matches? p }.map(&:title)
    ms.should == %w{5 10 15 20}
  end

  it 'queries multiple tags' do
    q = ArchiveQuery.new 'multiple-of-five_even'
    ms = posts.select { |p| q.matches? p }.map(&:title)
    ms.should == %w(2 4 5 6 8 10 12 14 15 16 18 20)
  end
end
