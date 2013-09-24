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

    render_404 unless @menu_item = Spree::MenuItem.find(Spree::MenuItem.id_from_cached_slug(path))
    @page = @menu_item.page
  end

  private
  def determine_layout
    return @menu_item.template if @menu_item && @menu_item.template.present?
    Spree::Config.layout
  end

end
