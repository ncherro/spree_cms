module Spree
  module CmsHelper

    def cms_image_tag(image, style)
      processed = image.file.thumb(style)
      image_tag processed.url, alt: image.alt, width: processed.width, height: processed.height
    end

    def cms_wrapper(obj, *args, &renderer)
      defaults = {
        content_method: 'content',
        css_class: nil,
        css_id: nil,
        wrapper_el: :div
      }
      options = defaults.merge(args.extract_options!)

      classes = []
      classes << 'cms-' + obj.class.name.demodulize.underscore.dasherize
      classes << options[:css_class] if options[:css_class].present?
      classes << obj.css_class if obj.respond_to?('css_class') && obj.css_class.present?

      if options[:css_id].present?
        id = options[:css_id]
      else
        id = obj.css_id if obj.respond_to?('css_id') && obj.css_id.present?
      end

      content_tag(options[:wrapper_el], renderer.call(obj), class: classes.join(' '), id: id)
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
      item_classes = []
      item_classes << 'unpublished' unless menu_item.is_published?
      item_classes << menu_item.css_class if menu_item.css_class.present?
      # if this is in the current tree
      # OR this is a menu item with a URL and the current path begins with the URL
      item_classes << 'cms-active' if options[:path_ids].include?(menu_item.id) || menu_item.url.present? && request.fullpath.split('?').first.starts_with?(menu_item.url)
      # if this is at the bottom of the current tree
      # OR this is a menu item with a URL, and the current path equals the URL
      item_classes << 'cms-on' if options[:path_ids].last == menu_item.id || menu_item.url.present? && menu_item.url == request.fullpath.split('?').first
      if options[:override_id]
        item_id = %( id="#{menu_item.id}")
      else
        item_id = menu_item.css_id.present? ? %( id="#{menu_item.css_id}") : ''
      end
      if options[:link_renderer]
        link_html = options[:link_renderer].call(menu_item)
      else
        # default
        if options[:item_wrapper_el].present?
          link_opts = {}
        else
          link_opts = {
            class: item_classes.join(' '),
            id: menu_item.id,
          }
        end
        link_html = link_to(menu_item.title, menu_item.href, link_opts)
      end
      s = ""
      if options[:item_wrapper_el].present?
        s << %(<#{options[:item_wrapper_el]}#{' class="' + item_classes.join(' ') + '"' if item_classes.any?}#{item_id} rel="#{menu_item.id}">)
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
        root_id: nil,
        depth: 0,
        wrapper_el: 'ul',
        submenu_wrapper_el: 'ul',
        item_wrapper_el: 'li',
        only_visible: false,
        wrapper_class: "cms-menu",
        override_id: false,
        cache: true,
        path_ids: [],
      }
      options = defaults.merge(args.extract_options!)

      r = ""
      r << %(<#{options[:wrapper_el]} id="#{options[:wrapper_id]}" class="#{options[:wrapper_class]}">) if options[:wrapper_el].present?

      if options[:root_id]
        items = menu.menu_items.order(:position).where(id: options[:root_id])
      else
        # start at the root
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

    # NOTE: this method exists in Rails 4
    # https://github.com/rails/rails/blob/4-0-stable/actionpack/lib/action_view/helpers/cache_helper.rb
    # but not Rails 3.2
    # https://github.com/rails/rails/blob/3-2-stable/actionpack/lib/action_view/helpers/cache_helper.rb
    def cache_if(condition, name = {}, options = nil, &block)
      if condition
        cache(name, options, &block)
      else
        yield
      end
      nil
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
        cache: true,
      }
      options = defaults.merge(args.extract_options!)

      # using a fragment cache here
      cache_if options.delete(:cache), [menu_block, menu_block.fragment_cache_options(request.fullpath, options)] do
        path = Spree::CmsRoutes.remove_spree_mount_point(request.fullpath)

        mi = nil
        if menu_block.sets_active_tree? || menu_block.follows_current?
          # find_by_id to avoid ActiveRecord error
          mi = Spree::MenuItem.find_by_id(Spree::MenuItem.id_from_cached_slug(path))
        end

        if menu_block.follows_current?
          # attempt to find the current menu
          if mi
            safe_concat(render_menu_tree(
              mi.menu,
              options.merge({
                only_visible: true,
                root_id: (menu_block.shows_children? ? mi.id : mi.parent_id),
                path_ids: mi.path_ids,
              })
            ))
          end
        else
          safe_concat(render_menu_tree(
            menu_block.menu,
            options.merge({
              only_visible: true,
              root_id: menu_block.spree_menu_item_id,
              path_ids: (mi ? mi.path_ids : []),
            })
          ))
        end
      end

    end

  end
end
