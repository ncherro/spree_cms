class Spree::Admin::CmsBaseController < Spree::Admin::ResourceController

  protected
  def collection
    return @collection if @collection.present?
    @collection = super.page(params[:page])
  end

end
