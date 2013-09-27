module Spree
  class CmsRoutes
    def self.add_spree_mount_point(path)
      Rails.application.routes.url_helpers.spree_path + path
    end

    def self.remove_spree_mount_point(path)
      regex = Regexp.new '\A' + Rails.application.routes.url_helpers.spree_path
      path.sub(regex, '').split('?')[0]
    end

    def self.matches?(request)
      full_slug = Spree::CmsRoutes::remove_spree_mount_point(request.fullpath)

      Rails.logger.info("\n\n\nlooking for #{full_slug}\n\n\n")

      Rails.cache.fetch("#{Spree::MenuItem::CACHE_PREFIX}#{full_slug}-exists") do
        Spree::MenuItem.published.by_cached_slug(full_slug).exists?
      end
    end
  end
end
