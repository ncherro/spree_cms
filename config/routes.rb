module Cms
  def self.remove_spree_mount_point(path)
    regex = Regexp.new '\A' + Rails.application.routes.url_helpers.spree_path
    path.sub(regex, '').split('?')[0]
  end
end

class Spree::Cms
  def self.matches?(request)
    full_slug = Cms::remove_spree_mount_point(request.fullpath)
    Rails.cache.fetch("#{Spree::MenuItem::CACHE_PREFIX}#{full_slug}-exists") do
      Spree::MenuItem.published.by_cached_slug(full_slug).exists?
    end
  end
end

Spree::Core::Engine.routes.prepend do

  namespace :admin do
    get '/cms', to: redirect('/admin/menus'), as: 'cms'

    # NOTE: we are being lazy here
    get '/html_blocks', to: redirect('/admin/blocks'), as: 'html_blocks'
    get '/menu_blocks', to: redirect('/admin/blocks'), as: 'menu_blocks'
    get '/static_blocks', to: redirect('/admin/blocks'), as: 'static_blocks'

    resources :blocks, only: [:index]
    resources :menu_blocks, :static_blocks, :html_blocks, except: [:index]
    resources :layouts
    resources :menu_items do
      post 'update_positions', on: :collection
      post 'update_parent', on: :member
    end
    resources :menus do
      get 'menu_item_options', on: :member
    end
  end

  constraints(Spree::Cms) do
    get '/*path', to: 'cms#show', as: 'cms'
  end

end
