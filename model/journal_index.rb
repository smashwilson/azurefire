require 'haml'
require_relative 'journal_post'

# Creates an index of JournalPosts from the contents of one or more directories.
# Parses each entry into a JournalPost object, outputs views of them into a
# destination directory, and constructs a variety of index files that sort and
# organize them in various ways.
class JournalIndex
  attr_accessor :sources, :destination, :posts
  attr_accessor :latest_count
  
  def initialize
    @sources = []
    @posts = []
    @latest_count = 5
  end
  
  def view_base
    File.expand_path('../views', File.dirname(__FILE__))
  end

  def view path
    File.join(view_base, path)
  end

  def scan
    @sources.each do |source_dir|
      Dir["#{source_dir}/*.md"].each do |entry|
        @posts << JournalPost.from(entry) 
      end
    end
  end

  def render!
    render_content
    render_latest
  end

  def render_content
    template = File.open(view('partial_post.haml'), 'r') { |f| f.read nil }
    engine = Haml::Engine.new(template)
    @posts.each do |post|
      html = engine.render(Object.new, :post => post)
      File.open(File.join(@destination, "#{post.filename}.html"), 'w') do |outf|
        outf.print(html)
      end
    end
  end

  def render_latest
    File.open(File.join(@destination, 'latest.html'), 'w') do |outf|
      @posts.sort.take(@latest_count).each do |post|
        outf.puts(File.read(post.html_file))
      end
    end
  end

end