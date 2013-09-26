module Spree
  module CmsHelper

    def cms_wrapper(obj, *args, &renderer)
      defaults = {
        content_method: 'content',
      }
      options = defaults.merge(args.extract_options!)

      classes = []
      classes << 'cms-' + obj.class.name.demodulize.underscore.dasherize
      classes << obj.css_class if obj.respond_to?('css_class') && obj.css_class.present?

      id = obj.css_id if obj.respond_to?('css_id') && obj.css_id.present?

      content_tag(:div, renderer.call(obj), class: classes.join(' '), id: id)
    end

    def render_admin_menu_tree(menu)
      render_menu_tree(@menu) do |node|
        actions = []
        actions << link_to("+ Add child", new_admin_menu_item_url(menu_id: params[:menu_id], parent_id: node.id))
        actions << link_to("/ Edit", edit_admin_menu_item_url(node))
        actions << link_to("x Delete", admin_menu_item_url(node), method: "delete")
        r = %(<div class="wrap">#{link_to(node.title, node.href)})
        r << " id = #{node.id}, pos = #{node.position}, ancestry = #{node.ancestry} " if params[:debug]
        r << " - #{node.href}#{' - unpublished' unless node.is_published?}#{' - not visible' unless node.is_visible_in_menu?}"
        r << %(<div class="actions">)
        r << actions.join(' | ')
        r << %(</div></div>).html_safe
      end
    end

    def render_menu_tree(menu, *args, &link_func)
      defaults = {
        follow_current: false,
        root_id: nil,
        depth: 0,
        wrapped: false,
        only_visible: false,
        wrapper_class: "cms-menu",
      }
      options = defaults.merge(args.extract_options!)

      req = request.fullpath

      r = ""
      r << %(<ul class="#{options[:wrapper_class]}">) if options[:wrapped]

      if options[:root_id]
        items = menu.menu_items.order(:position).where(id: options[:root_id])
      else
        items = menu.menu_items.order(:position).where(ancestry_depth: 0)
      end

      items = items.visible if options[:only_visible]

      func = lambda do |nodes|
        return "" if nodes.empty?
        return '<ul>' + nodes.inject("") do |string, (node, children)|
          if link_func
            link_html = link_func.call(node)
          else
            link_html = link_to(node.title, node.href)
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
          link_html = link_to(item.title, item.href)
        end
        li_classes = []
        li_classes << 'unpublished' unless item.is_published?
        r << %(<li#{' class="' + li_classes.join(' ') + '"' if li_classes.any?} id="#{item.id}" rel="#{item.id}">#{link_html})
        r << func.call(item.descendants.arrange)
        r << %(</li>)
      end

      r << %(</ul>) if options[:wrapped]

      r.html_safe
    end

    def render_menu_block(menu_block)
      render_menu_tree(
        menu_block.menu,
        only_visible: true,
        follow_current: menu_block.follows_current?,
        root_id: menu_block.menu_item_id,
        depth: menu_block.max_levels,
        wrapped: menu_block.wrapped?
      )
    end

  end
end
