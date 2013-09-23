class Spree::Admin::MenusController < Spree::Admin::CmsBaseController

  def menu_item_options
    if params[:menu_item_id]
      possible_parents = Spree::MenuItem.find(params[:menu_item_id]).possible_parents
    else
      possible_parents = nil
    end
    @items = Spree::MenuItem.where(spree_menu_id: params[:id]).arrange_as_array({order: 'slug'}, possible_parents)
  end

end
