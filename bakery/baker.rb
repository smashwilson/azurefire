require 'json'
require 'haml'
require 'rdiscount'
require 'fileutils'

require_relative '../settings'
require_relative '../model/journal_post'

class PostError
  attr_accessor :meta, :reason

  def initialize meta, reason
    @meta, @reason = meta, reason
  end
end

class Baker
  attr_reader :errors

  SiteRoutes = ['news', 'archive', 'about']

  def initialize
    @errors = []
  end

  def post_engine
    @post_template_path ||= Settings.current.view_root + '/partial_post.haml'
    @post_template ||= File.read(@post_template_path)
    @post_engine ||= Haml::Engine.new(@post_template,
      :filename => @post_template_path)
  end

  def bake_post path
    File.open(path, 'r') do |inf|
      # Load and verify the post metadata.
      meta = JournalPostMetadata.load(inf)
      next nil unless validate_meta?(meta)

      # Bake the post content into html using the post template.
      outpath = JournalPost.path_for(meta)
      FileUtils.mkdir_p(File.dirname(outpath))
      File.open(outpath, 'w') do |outf|
        body = RDiscount.new(inf.read, :filter_html).to_html
        outf.print(post_engine.render(Object.new, :meta => meta, :body => body))
      end

      # Create the comment directory and empty index.
      commentpath = JournalPost.comment_path_for(meta)
      FileUtils.mkdir_p(commentpath)
      File.open(File.join(commentpath, 'index'), 'w+') { |f| }

      meta
    end
  end

  def validate_meta? meta
    if SiteRoutes.include?(meta.slug)
      errors << PostError.new(meta, "Post title \"#{meta.slug}\" collides with an existing route")
      return false
    end
    true
  end

end
