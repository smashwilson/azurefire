require_relative 'post_index'

class FrontpageIndex < PostIndex
  attr_accessor :count

  def initialize
    super
    @count = 5
  end

  def path
    'posts/frontpage.index'
  end

  def metas posts
    posts.sort.take(@count)
  end

  def write_meta meta
    meta.slug
  end

end
