class Spree::Admin::MenuItemsController < Spree::Admin::CmsBaseController
  before_filter :set_menu

  helper "spree/cms"

  def new
    invoke_callbacks(:new_action, :before)

    # overriding to set these
    @object.spree_menu_id = params[:menu_id] if params[:menu_id]
    @object.parent_id = params[:parent_id] if params[:parent_id]

    respond_with(@object) do |format|
      format.html { render layout: !request.xhr? }
      format.js { render layout: false }
    end
  end

  private
  def set_menu
    @menu = Spree::Menu.find(params[:menu_id]) if params[:menu_id]
  end

end
