# Simple main and sub navigation.  Should be #included within a #helpers
# block.  Use a set of #nav_item calls to build the menu structure, passing
# blocks to defined subnavigation menus, then invoke #navigation to output the
# current menu structure.
module Navigation
  
  # Append a navigation item to the current navigation menu.  If a block is
  # provided, it will be invoked (to construct a subnavigation menu) when this
  # item is current.
  def nav_item name, link = "/#{name}", &subnav_block
    @navigation ||= []
    
    css_class = ''
    if request.path_info.start_with? link
      @subnavigation = subnav_block
      css_class = " class='current' "
    end
    @navigation << "\t<li><a #{css_class} href='#{link}'>#{name}</a></li>\n"
  end
  
  # Generate a navigation menu.  If the current item was declared with a
  # subnavigation block, it will be invoked after the navigation items have
  # been reset to build a sub-navigation menu.
  def navigation klass = 'main-navigation'
    items, subnav_block = @navigation, @subnavigation
    @navigation, @subnavigation = [], nil
    
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