require 'spec_helper'

describe '/news' do
  include WebHelpers
  before { setup_storage }
  after { teardown_storage }

  def fixt_root
    File.join(super, 'set')
  end

  before { Baker.new.bake! }

  it 'displays the most recent posts' do
    get '/'
    ok!

    posts = @doc.css('div.post')

    exp_titles = ['Post 20', 'Post 19', 'Post 18', 'Post 17', 'Post 16']
    posts.css('.header h2.title').map(&:content).should == exp_titles
  end

  it 'shows post tags' do
    get '/'
    ok!

    tags = @doc.at_css('div.post').css('ul.tags a').map(&:content)
    tags.should == %w{numbered multiple-of-five}
  end

  it 'shows a quote-of-the-day' do
    get '/'
    ok!

    qotd = @doc.at_css('div.qotd').content
    qotd.should =~ /^This is the (first|second) quote in the quote file!$/
  end
end
