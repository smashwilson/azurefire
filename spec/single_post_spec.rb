require 'spec_helper'

describe '/<post-slug>' do
  include WebHelpers
  before { setup_storage }
  after { teardown_storage }

  def fixt_root
    File.join(super, 'set')
  end

  before { Baker.new.bake! }

  it 'gives a 404 for unknown posts' do
    get '/nonsense'
    last_response.status.should == 404
  end

  it 'renders the post body' do
    get '/post-10'
    ok!
 
    @doc.at_css('.markdown p').content.should =~ / ten /
  end

  it 'accepts a comment POST' do
    pending 'comments disabled'

    post '/post-10', name: 'someone', body: "# heading\n\nbody"
    follow_redirect!
    ok!

    @doc.css('ul.comments li').should have(2).items
    @doc.at_css('ul.comments .name').content.should == 'someone'
    @doc.at_css('ul.comments .markdown h1').content.should == 'heading'
    @doc.at_css('ul.comments .markdown p').content.should == 'body'
  end

  it 'gives a 404 when attempting to POST a comment to a missing post' do
    pending 'comments disabled'

    post '/huuurf', name: 'me', body: 'in your face!'
    last_response.status.should == 404
  end

  it 'shows the current comment count' do
    pending 'comments disabled'

    post '/post-10', name: 'first', body: 'First comment'
    post '/post-10', name: 'second', body: 'Second comment'
    post '/post-10', name: 'third', body: 'Third comment'

    follow_redirect!
    ok!

    @doc.at_css('li.comment-count').content.strip.should == 'comments (3)'
  end

  it 'displays a live preview' do
    post '/markdown-preview', body: '# heading line'
    ok!

    last_response.body.chomp.should == '<h1>heading line</h1>'
  end

  it 'should show next and previous links' do
    get '/post-10'
    ok!

    nlink = @doc.at_css('a.next')
    nlink[:href].should == '/post-11'
    nlink.content.should == 'Post 11'

    plink = @doc.at_css('a.prev')
    plink[:href].should == '/post-9'
    plink.content.should == 'Post 9'
  end

  it 'should activate the /news nav link' do
    get '/post-10'
    ok!

    current_nav = @doc.at_css('ul.navigation li a.current')
    current_nav.content.should == 'news'
  end
end
