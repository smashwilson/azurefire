require 'spec_helper'

describe Baker do
  include StorageHelpers
  before { setup_storage }
  after { teardown_storage }

  context 'baking a post' do
    subject { Baker.new.bake_post(fixt_path 'sample.md') }

    its(:author) { should == 'sample' }
    its(:title) { should == 'Sample Post' }
    its(:slug) { should == 'sample-post' }
    its(:timestamp) { should == Time.parse('8am 17 Sept 2011') }
    its(:tags) { should == %w{sample lorem} }

    it 'bakes to html' do
      subject
      File.exist?(temp_path 'posts', 'sample-post.html').should be_true
    end

    it 'renders metadata and content to html' do
      subject
      doc = Nokogiri::XML(File.read(temp_path 'posts', 'sample-post.html'))
      doc.at_css('.header span.author').content.should == 'sample'
      doc.at_css('.header span.timestamp').content.should == 'Sat 17 Sep 2011  8:00am'
      doc.at_css('.header h2.title').content.should == 'Sample Post'

      File.exist?(temp_path 'comments', 'sample-post', 'index').should be_true
      File.read(temp_path 'comments/sample-post/index').should == ''
    end
  end
end
