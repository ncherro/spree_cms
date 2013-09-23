module Spree::CmsHelper

  def render_menu_tree(menu, *args, &link_func)
    defaults = {
      follow_current: false,
      root_id: nil,
      depth: 0,
      wrapped: false,
      wrapper_class: "cms-menu",
    }

    options = defaults.merge(args.extract_options!)

    req = request.fullpath

    r = ""
    r << %(<ul class="#{options[:wrapper_class]}">) if options[:wrapped]

    if options[:root_id]
      items = menu.menu_items.where(id: options[:root_id])
    else
      items = menu.menu_items.where(ancestry_depth: 0)
    end

    func = lambda do |nodes|
      return "" if nodes.empty?
      return '<ul>' + nodes.inject("") do |string, (node, children)|
        if link_func
          link_html = link_func.call(node)
        else
          link_html = link_to(node.title, node.url)
        end
        li_classes = []
        li_classes << 'unpublished' unless node.is_published?
        %(#{string}<li#{' class="' + li_classes.join(' ') + '"' if li_classes.any?} rel="#{node.id}">#{link_html}#{func.call(children)}</li>)
      end + '</ul>'
    end

    items.each do |item|
      if link_func
        link_html = link_func.call(item)
      else
        link_html = link_to(item.title, item.url)
      end
      li_classes = []
      li_classes << 'unpublished' unless item.is_published?
      r << %(<li#{' class="' + li_classes.join(' ') + '"' if li_classes.any?} rel="#{item.id}">#{link_html})
      r << func.call(item.descendants.arrange)
      r << %(</li>)
    end

    r << %(</ul>) if options[:wrapped]

    r.html_safe
  end

end
