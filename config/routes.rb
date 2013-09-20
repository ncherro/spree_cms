module Cms
  def self.remove_spree_mount_point(path)
    regex = Regexp.new '\A' + Rails.application.routes.url_helpers.spree_path
    path.sub(regex, '').split('?')[0]
  end
end

class Spree::Cms
  def self.matches?(request)
    slug = Cms::remove_spree_mount_point(request.fullpath)
    menu_items = Spree::MenuItem.arel_table
    Spree::MenuItem.visible.by_slug(slug).exists?
  end
end

Spree::Core::Engine.routes.prepend do

  namespace :admin do
    get '/cms', to: redirect('/admin/menus'), as: 'cms'
    resources :menus, :pages, :layouts, :blocks
  end

  constraints(Spree::Cms) do
    get '/*path', to: 'cms#show', as: 'cms'
  end

end
