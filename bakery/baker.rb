require 'json'
require 'haml'
require 'rdiscount'
require 'fileutils'

require_relative '../settings'
require_relative '../model/journal_post'

require_relative 'journal_post_metadata'
require_relative 'archive_index'
require_relative 'frontpage_index'

class Baker
  attr_reader :errors

  SiteRoutes = ['news', 'archive', 'about']

  def initialize
    @errors = []
    @indices = [ArchiveIndex.new, FrontpageIndex.new]
  end

  def bake!
    post_paths = Settings.current.post_dirs.map do |post_dir|
      Dir["#{post_dir}/*.#{Settings.current.post_ext}"]
    end.flatten

    progress = BakerProgress.new(post_paths.size)
    metas = post_paths.map do |path|
      meta = bake_post(path)
      progress.increment meta
      yield progress if block_given?
      meta
    end.reject { |e| e.nil? }.sort

    @indices.each { |ind| ind.create! metas }
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
      meta = validate_meta(File.basename(inf.path)) do
        JournalPostMetadata.load(inf)
      end
      next nil if meta.nil?

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

  def validate_meta(filename)
    m = nil
    begin
      m = yield
    rescue JSON::ParserError
      errors << PostError.new(m, "Malformed JSON header in post \"#{filename}\".")
      return nil
    end

    if SiteRoutes.include?(m.slug)
      errors << PostError.new(m, "Post title \"#{m.slug}\" collides with an existing route")
      return nil
    end
    m
  end

  class BakerProgress
    attr_accessor :total, :current, :errors, :meta

    def initialize total
      @total, @current, @errors, @meta = total, 0, 0, nil
    end

    def increment meta
      @current += 1
      @errors += 1 if meta.nil?
      @meta = meta
    end
  end

  class PostError
    attr_accessor :meta, :reason

    def initialize meta, reason
      @meta, @reason = meta, reason
    end
  end

end
