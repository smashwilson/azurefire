require_relative '../azure'

require 'test/unit'
require 'rack/test'
require 'nokogiri'

ENV['RACK_ENV'] = 'test'

require_relative 'storage_test_case'

class WebTestCase < StorageTestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def ok!
    puts last_response.errors if last_response.errors
    assert last_response.ok?, "Last response #{last_response.status}:\n#{last_response.body}"
    parse
  end

  def parse
    @doc = Nokogiri::HTML(last_response.body)
  end

  def assert_one nodes, query
    assert_equal 1, nodes.size, "One and only one match expected for '#{query}'"
    @node = nodes[0]
  end

  def assert_no_css css_string
    parse unless @doc
    assert_equal 0, @doc.css(css_string).size
  end

  def assert_css css_string
    parse unless @doc
    assert_one @doc.css(css_string), css_string
  end

  def assert_xpath xpath_string
    parse unless @doc
    assert_one @doc.xpath(xpath_string), xpath_string
  end

end
