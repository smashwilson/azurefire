require 'rdiscount'

require_relative '../settings'

class JournalPost

  def self.path_for meta
    File.join(Settings.current.data_root, 'posts', "#{meta.slug}.html")
  end

end
