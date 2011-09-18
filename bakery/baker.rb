require 'json'
require 'haml'
require 'rdiscount'
require 'fileutils'

require_relative '../settings'
require_relative '../model/journal_post'

class Baker

  def post_engine
    @post_template_path ||= Settings.current.view_root + '/partial_post.haml'
    @post_template ||= File.read(@post_template_path)
    @post_engine ||= Haml::Engine.new(@post_template,
      :filename => @post_template_path)
  end

  def bake_post path
    File.open(path, 'r') do |inf|
      meta = JournalPostMetadata.load(inf)
      outpath = JournalPost.path_for(meta)
      FileUtils.mkdir_p(File.dirname(outpath))
      File.open(outpath, 'w') do |outf|
        body = RDiscount.new(inf.read, :filter_html).to_html
        outf.print(post_engine.render(Object.new, :meta => meta, :body => body))
      end
      meta
    end
  end

end
