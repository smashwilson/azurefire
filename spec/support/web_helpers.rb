require_relative 'storage_helpers'

require 'nokogiri'

module WebHelpers
  include StorageHelpers

  def app
    Sinatra::Application
  end

  def ok!
    puts last_response.errors if last_response.errors
    last_response.should be_ok
    parse
  end

  def parse
    @doc = Nokogiri::HTML(last_response.body)
  end

  def only nodes
    nodes.size.should == 1
    @node = nodes[0]
  end

  def no_css css_string
    parse unless @doc
    @doc.css(css_string).should be_empty
  end

  def css_match css_string
    parse unless @doc
    only(@doc.css css_string)
  end

  def xpath_match xpath_string
    parse unless @doc
    only(@doc.xpath xpath_string)
  end
end
