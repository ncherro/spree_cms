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
      render_menu_tree(@menu, override_id: true, wrapper_el: nil) do |node|
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

    def render_menu_item(menu_item, children, options)
      li_classes = []
      li_classes << 'unpublished' unless menu_item.is_published?
      li_classes << menu_item.css_class if menu_item.css_class.present?
      if options[:override_id]
        li_id = %( id="#{menu_item.id}")
      else
        li_id = menu_item.css_id.present? ? %( id="#{menu_item.css_id}") : ''
      end
      if options[:link_renderer]
        link_html = options[:link_renderer].call(menu_item)
      else
        # default
        link_html = link_to(menu_item.title, menu_item.href)
      end
      s = ""
      if options[:item_wrapper_el].present?
        s << %(<#{options[:item_wrapper_el]}#{' class="' + li_classes.join(' ') + '"' if li_classes.any?}#{li_id} rel="#{menu_item.id}">)
      end
      # recursion
      s << "#{link_html}#{options[:callback].call(children)}"
      if options[:item_wrapper_el].present?
        s << "</#{options[:item_wrapper_el]}>"
      end
      s
    end

    def render_menu_tree(menu, *args, &link_func)
      defaults = {
        follow_current: false,
        root_id: nil,
        depth: 0,
        wrapper_el: 'ul',
        submenu_wrapper_el: 'ul',
        item_wrapper_el: 'li',
        only_visible: false,
        wrapper_class: "cms-menu",
        override_id: false
      }
      options = defaults.merge(args.extract_options!)

      req = request.fullpath

      r = ""
      r << %(<#{options[:wrapper_el]} id="#{options[:wrapper_id]}" class="#{options[:wrapper_class]}">) if options[:wrapper_el].present?

      if options[:root_id]
        items = menu.menu_items.order(:position).where(id: options[:root_id])
      else
        items = menu.menu_items.order(:position).where(ancestry_depth: 0)
      end

      items = items.visible if options[:only_visible]

      cur_depth = 0
      func = lambda do |nodes|
        cur_depth += 1
        return "" if nodes.empty? || !options[:depth].zero? && cur_depth >= options[:depth]
        return "<#{options[:submenu_wrapper_el]}>" + nodes.inject("") do |string, (node, children)|
          string + render_menu_item(node, children, options.merge({ callback: func, link_renderer: link_func }))
        end + "</#{options[:submenu_wrapper_el]}>"
      end

      # build the roots
      items.each do |item|
        r << render_menu_item(
          item,
          item.descendants.arrange,
          options.merge({ callback: func, link_renderer: link_func })
        )
      end
      r << %(</#{options[:wrapper_el]}>) if options[:wrapper_el].present?
      r.html_safe
    end


    # NOTE: this should be the only front-facing helper method
    def render_menu_block(menu_block, *args)
      defaults = {
        depth: 0,
        wrapper_el: 'ul',
        submenu_wrapper_el: 'ul',
        item_wrapper_el: 'li',
        wrapper_class: "cms-menu",
        wrapper_id: nil,
      }
      options = defaults.merge(args.extract_options!)

      render_menu_tree(
        menu_block.menu,
        options.merge({
          only_visible: true,
          follow_current: menu_block.follows_current?,
          root_id: menu_block.menu_item_id,
        })
      )
    end

  end
end
