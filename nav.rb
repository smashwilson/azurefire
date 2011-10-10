# Simple, single-level site navigation. Should be #included within a #helpers
# block.  Use a set of #nav calls to build the menu structure, then invoke #navigation
# to output the current menu structure.
module NavigationHelper

  class NavigationItem
    attr_accessor :name, :link, :default

    def initialize name, link, default
      @name, @link, @default = name, link, default
    end

    def match? path
      return true if @default && path == '/'
      path.start_with? @link
    end
  end

  # Construct a new navigation menu. Invoke in a #before block to describe the site navigation structure.
  def menu
    @navigation = []
    yield
  end

  # Append a navigation item to the current navigation menu.
  def nav name, options = {}
    link = options[:link] || "/#{name}"
    default = options[:default] || false

    @navigation << NavigationItem.new(name, link, default)
  end

  # Render a navigation menu.  If the current item was declared with a
  # subnavigation block, it will be invoked after the navigation items have
  # been reset to build a sub-navigation menu.
  #
  # If the @navigate_as instance variable is set, it will be used instead of the
  # request path to determine the currently active navigation item.
  def navigation
    @navigate_as ||= request.path_info
    current = @navigation.detect { |item| item.match? @navigate_as }
    navstrs = @navigation.map do |item|
      css_class = item.eql?(current) ? ' class="current"' : ''
      "<li><a#{css_class} href=\"#{item.link}\">#{item.name}</a></li>"
    end
    <<ENDNAV
<ul class="navigation">
  #{navstrs.join("\n\t")}
</ul>
ENDNAV
  end

end
