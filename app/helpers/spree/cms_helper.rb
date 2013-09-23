module Spree::CmsHelper

  def render_menu_tree(menu, *args)
    defaults = {
      follow_current: false,
      parent_id: nil,
      depth: 0,
      wrapped: true
    }

    options = defaults.merge(args.extract_options!)

    req = request.fullpath
    r = ""

    r << %('<ul>') if options[:wrapped]

    if options[:parent_id]
      tree = menu.menu_items.find(options[:parent_id]).subtree
    else
      tree = menu.menu_items.from_depth(0)
      tree = tree.to_depth(options[:depth]) unless options[:depth].zero?
      tree = tree.arrange_as_array
    end

    raise tree.to_yaml

    r << %('</ul>') if options[:wrapped]
    r.html_safe
  end

end
