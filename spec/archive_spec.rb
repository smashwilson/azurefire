require 'spec_helper'

describe '/archive' do
  include WebHelpers

  def fixt_root
    File.join(__dir__, 'fixtures', 'set')
  end

  before do
    setup_storage
    Baker.new.bake!
  end

  after { teardown_storage }

  it 'shows posts' do
    get '/archive'
    ok!

    results = @doc.css('ul.results > li')
    results.should have(20).items

    top = results[0]
    top.at_css('span.timestamp').content.should == 'Tue 20 Sep 2011  8:00am'
    top.at_css('a').content.should == 'Post 20'

    second = results[1]
    second.at_css('span.timestamp').content.should == 'Mon 19 Sep 2011  8:00am'
    second.at_css('a').content.should == 'Post 19'
  end

  it 'can be queried by tag' do
    get '/archive/special_multiple-of-five'
    ok!

    results = @doc.css('ul.results > li')
    results.should have(6).items

    expected = [20, 15, 10, 7, 5, 3].map { |n| "Post #{n}" }
    results.map { |r| r.at_css('a').content }.should == expected
  end

  it 'shows the empty query' do
    get '/archive'
    ok!

    q = @doc.at_css('.query p.current').content
    q.should == 'You are currently viewing all posts.'
  end

  it 'shows a single-tag query' do
    get '/archive/special'
    ok!

    q = @doc.at_css('.query p.current').content
    q.should == 'You are currently viewing posts tagged special.'
  end

  it 'shows a multiple-tag query' do
    get '/archive/special_multiple-of-five'
    ok!

    q = @doc.at_css('.query p.current').content
    q.should == 'You are currently viewing posts tagged special or multiple-of-five.'
  end
end
