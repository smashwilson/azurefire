require 'spec_helper'

describe '/<post-slug>' do
  include WebHelpers
  include Honeypot

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
    post '/post-10', name: 'someone', body: "# heading\n\nbody", rspec_secret: secret
    follow_redirect!
    ok!

    @doc.css('ul.comments li').should have(2).items
    @doc.at_css('ul.comments .name').content.should == 'someone'
    @doc.at_css('ul.comments .markdown h1').content.should == 'heading'
    @doc.at_css('ul.comments .markdown p').content.should == 'body'
  end

  it 'gives a 404 when attempting to POST a comment to a missing post' do
    post '/huuurf', name: 'me', body: 'in your face!'
    last_response.status.should == 404
  end

  context 'spam protection' do
    let(:ts) { Time.parse('1 Jan 2013 1am GMT') }
    let(:sp) { spinner(ts, '127.0.0.1', 'post-10') }

    before do
      Sinatra::Application.any_instance.stub(timestamp: ts)

      get '/post-10'
      ok!
      @form = @doc.at_css('ul.comments li.new form')
    end

    def klass_modulo nodes, factor
      nodes.should_not be_nil
      klasses = nodes[:class].split
      klasses.size.should == 1
      klasses.map { |kls| kls[/comment-(\d+)/] }.each do |numeric|
        (numeric.to_i % factor).should == 0
      end
    end

    it 'generates a spinner field' do
      @form.at_xpath('//input[@name="spinner"]')[:value].should == sp
    end

    it 'includes an obfuscated timestamp field' do
      ts_field = field_name(sp, 'timestamp')
      @form.at_xpath("//input[@name='#{ts_field}']")[:value].should == hash(ts.to_s)
    end

    it 'includes an obfuscated entry slug' do
      slug_field = field_name(sp, 'slug')
      @form.at_xpath("//input[@name='#{slug_field}']")[:value].should == hash('post-10')
    end

    it 'conceals the input names of the name field' do
      name_field = field_name(sp, 'name')
      klass_modulo @form.at_xpath("//input[@name='#{name_field}']"), 5
    end

    it 'conceals the name of the comment body field' do
      body_field = field_name(sp, 'body')
      klass_modulo @form.at_xpath("//textarea[@name='#{body_field}']"), 3
    end

    it 'obfuscates the submit button' do
      submit_field = field_name(sp, 'submit')
      klass_modulo @form.at_xpath("//input[@name='#{submit_field}']"), 7
    end

    it 'includes honeypot fields for the unwary bot'
  end

  it 'shows the current comment count' do
    post '/post-10', name: 'first', body: 'First comment', rspec_secret: secret
    post '/post-10', name: 'second', body: 'Second comment', rspec_secret: secret
    post '/post-10', name: 'third', body: 'Third comment', rspec_secret: secret

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
