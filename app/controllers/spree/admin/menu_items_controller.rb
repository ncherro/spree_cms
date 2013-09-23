class Spree::Admin::MenuItemsController < Spree::Admin::CmsBaseController
  before_filter :set_menu

  private
  def set_menu
    @menu = Spree::Menu.find(params[:menu_id]) if params[:menu_id]
  end

end
