class ArchiveQuery
  attr_accessor :tags

  def initialize query_string
    @tags = (query_string || '').split(/_/).reject { |t| t.empty? }
  end

  def matches? post
    @tags.empty? or ! (@tags & post.tags).empty?
  end

  def to_s
    return 'all posts' if @tags.empty?
    tagstr = @tags.size == 1 ? @tags[0] : "#{@tags[0..-2].join ', '} or #{@tags[-1]}"
    "posts tagged #{tagstr}"
  end

end
