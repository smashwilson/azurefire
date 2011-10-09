require 'json'
require 'haml'
require 'rdiscount'
require 'fileutils'

require_relative '../settings'
require_relative 'journal_post'
require_relative 'journal_post_metadata'

require_relative 'archive_index'

class Baker
  attr_reader :errors

  SiteRoutes = ['news', 'archive', 'about']

  def initialize
    @errors = []
    @filenames_by_slug = {}
    @index = ArchiveIndex.new
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
    end
    metas = metas.reject { |e| e.nil? }.sort

    @index.create! metas
  end

  def comment_engine
    @comment_template_path ||= Settings.current.view_root + '/partial_comment.haml'
    @comment_template ||= File.read(@comment_template_path)
    @comment_engine ||= Haml::Engine.new(@comment_template,
      :filename => @comment_template_path)
  end

  def bake_comment! post, comment
    FileUtils.mkdir_p(post.comment_path)
    path = File.join(post.comment_path, "#{comment.hash}.html")
    File.open(path, 'w') do |cfile|
      body = RDiscount.new(comment.content, :filter_html).to_html
      cfile.print(comment_engine.render(Object.new,
        :comment => comment, :body => body))
    end

    post.comment_index.append(comment)
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
      File.open(File.join(commentpath, 'index'), 'a') { |f| }

      meta
    end
  end

  def validate_meta(filename)
    m = nil
    begin
      m = yield
    rescue MetadataError => e
      errors << PostError.new(filename, e.message)
      return nil
    end

    if SiteRoutes.include?(m.slug)
      errors << PostError.new(filename,
          "Post title \"#{m.slug}\" collides with an existing route")
      return nil
    end

    unless m.tags.all? { |t| t =~ /^[a-zA-Z0-9-]+$/ }
      errors << PostError.new(filename,
          "Invalid character in tags of post \"#{filename}\".")
      return nil
    end

    dup_path = @filenames_by_slug[m.slug]
    if dup_path
      errors << PostError.new(filename,
          "Post path \"#{m.slug}\" is duplicated in \"#{dup_path}\" and \"#{filename}\".")
      return nil
    else
      @filenames_by_slug[m.slug] = filename
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
    attr_accessor :filename, :reason

    def initialize filename, reason
      @filename, @reason = filename, reason
    end
  end

end
