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
    render_404 unless @page = Spree::MenuItem.find(Spree::MenuItem.id_from_cached_slug(path))
  end

  private
  def determine_layout
    return @page.template if @page && @page.template.present?
  end

end