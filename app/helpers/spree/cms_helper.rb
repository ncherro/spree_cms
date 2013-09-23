module Spree::CmsHelper

  def render_menu_tree(menu, *args, &link)
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
        if link
          link_html = link.call(node)
        else
          link_html = link_to(node.title, node.url)
        end
        %(#{string}<li rel="#{node.id}">#{link_html}#{func.call(children)}</li>)
      end + '</ul>'
    end

    items.each do |item|
      if link
        link_html = link.call(item)
      else
        link_html = link_to(item.title, item.url)
      end
      r << %(<li rel="#{item.id}">#{link_html})
      r << func.call(item.descendants.arrange)
      r << %(</li>)
    end

    r << %(</ul>) if options[:wrapped]

    r.html_safe
  end

end
