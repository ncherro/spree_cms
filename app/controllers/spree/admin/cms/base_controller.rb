class Spree::Admin::Cms::BaseController < Spree::Admin::ResourceController

  protected
  def collection
    return @collection if @collection.present?
    @collection = super
    @collection = @collection.page(params[:page])
  end

end
