class Spree::CmsController < Spree::StoreController

  helper "spree/products"

  layout :determine_layout

  def show
    path = case params[:path]
           when Array
             "/#{params[:path].join("/")}"
           when String
             "/#{params[:path]}"
           when nil
             request.path
           end

    if @menu_item = Spree::MenuItem.find_by_id(Spree::MenuItem.id_from_cached_slug(path))
      if @menu_item.url.blank?
        @page = @menu_item.page
        @body_id = @page.layout_name.parameterize
      else
        # menu items with urls should link directly, but just in case...
        redirect_to @menu_item.url and return
      end
    else
      render_404
    end
  end

  private
  def determine_layout
    return "spree/cms/layouts/#{@menu_item.template}" if @menu_item && @menu_item.template.present?
    Spree::Config.layout
  end

end
