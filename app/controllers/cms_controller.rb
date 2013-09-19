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
    unless @page = Spree::MenuItem.visible.by_slug(path).first
      render_404
    end
  end

  private
  def determine_layout
    return @page.template if @page && @page.template.present?
  end

end
