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
    resources :cms_images do
      get 'find_or_create', on: :collection
      post 'submit_find_or_create', on: :collection
    end
  end

  constraints(Spree::CmsRoutes) do
    get '/*path', to: 'cms#show', as: 'cms'
  end

end
