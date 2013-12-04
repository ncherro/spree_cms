class Spree::Admin::MenuItemsController < Spree::Admin::CmsBaseController

  before_filter :set_menu, except: [:update_positions, :update_parent]

  helper "spree/cms"

  def update_parent
    @object.parent_id = params[:parent_id]
    @success = @object.save
    @menu = @object.menu
  end

  def update_positions
    params[:positions].each do |k, h|
      # just update, no callbacks
      Spree::MenuItem.update_all("position = #{h['position']}", "id = #{h['id']}")
    end
    render json: { success: true }
  end

  def new
    invoke_callbacks(:new_action, :before)

    # overriding to set defaults
    @object.spree_menu_id = params[:menu_id] if params[:menu_id]
    @object.parent_id = params[:parent_id] if params[:parent_id]
    @object.is_published = true
    @object.is_visible_in_menu = true

    respond_with(@object) do |format|
      format.html { render layout: !request.xhr? }
      format.js { render layout: false }
    end
  end

  protected
  def location_after_save
    collection_url(menu_id: @object.spree_menu_id)
  end
  
  def location_after_destroy
    collection_url(menu_id: @object.spree_menu_id)
  end
  
  def collection
    return @collection if @collection.present?
    # no pagination (!)
    @collection = super
  end

  private
  def set_menu
    @menu = Spree::Menu.find(params[:menu_id]) if params[:menu_id]
  end

end
