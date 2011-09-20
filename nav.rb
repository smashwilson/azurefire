# Simple main and sub navigation.  Should be #included within a #helpers
# block.  Use a set of #nav calls to build the menu structure, passing
# blocks to defined subnavigation menus, then invoke #navigation to output the
# current menu structure.
module NavigationHelper

  def nav_match? path, link, default
    if default
      return true if path == '/' or path == @subnav_parent
    end
    path.start_with? link
  end

  # Append a navigation item to the current navigation menu.  If a block is
  # provided, it will be invoked (to construct a subnavigation menu) when this
  # item is current.
  def nav name, options = {}, &subnav_block
    @navigation ||= []

    link = options[:link] || "#{@subnav_parent}/#{name}"
    default = options[:default] || false

    css_class = ''
    if nav_match? request.path_info, link, default
      @subnav_block = subnav_block
      @next_subnav_parent = link
      css_class = " class='current' "
    end

    @navigation << "\t<li><a #{css_class} href='#{link}'>#{name}</a></li>\n"
  end

  # Generate a navigation menu.  If the current item was declared with a
  # subnavigation block, it will be invoked after the navigation items have
  # been reset to build a sub-navigation menu.
  def navigation klass = 'main-navigation'
    items, @navigation = @navigation, nil
    subnav_block, @subnav_block = @subnav_block, nil
    @next_subnav_parent, @subnav_parent = nil, @next_subnav_parent

    output = <<ENDNAV
<ul class="#{klass}">
#{items.join}
</ul>
ENDNAV

    if subnav_block
      subnav_block.call
      output += navigation 'sub-navigation'
    end
    output
  end

end
