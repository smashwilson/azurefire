require 'rdiscount'

require_relative '../settings'

class JournalPost

  def self.path_for meta, settings = Settings.instance
    File.join(settings.data_root, 'posts', "#{meta.slug}.html")
  end

end
