require 'json'
require 'rdiscount'
require 'fileutils'

require_relative '../settings'
require_relative '../model/journal_post'

class Baker

  def initialize settings = Settings.instance
    @settings = settings
  end

  def bake_post path
    File.open(path, 'r') do |inf|
      meta = JournalPostMetadata.load(inf)
      outpath = JournalPost.path_for(meta, @settings)
      FileUtils.mkdir_p(File.dirname(outpath))
      File.open(outpath, 'w') do |outf|
        outf.puts(RDiscount.new(inf.read, :filter_html).to_html)
      end
      meta
    end
  end

end
