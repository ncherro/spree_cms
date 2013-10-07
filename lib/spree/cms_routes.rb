module Spree
  class CmsRoutes
    def self.add_spree_mount_point(path)
      path = '' if path == '-'
      Rails.application.routes.url_helpers.spree_path + path
    end

    def self.remove_spree_mount_point(path)
      regex = Regexp.new '\A' + Rails.application.routes.url_helpers.spree_path
      path = path.sub(regex, '').split('?')[0]
      path = '-' if path.blank?
      path
    end

    def self.matches?(request)
      full_slug = Spree::CmsRoutes::remove_spree_mount_point(request.fullpath)
      Rails.cache.fetch("#{Spree::MenuItem::CACHE_PREFIX}#{full_slug}-exists") do
        Spree::MenuItem.published.by_cached_slug(full_slug).exists?
      end
    end
  end
end
