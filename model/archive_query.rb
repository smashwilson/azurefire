class ArchiveQuery
  attr_accessor :tags

  def initialize query_string
    @tags = (query_string || '').split(/_/).reject { |t| t.empty? }
  end

  def matches? post
    @tags.empty? or ! (@tags & post.tags).empty?
  end

end
