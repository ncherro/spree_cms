class Spree::Admin::CmsFilesController < Spree::Admin::CmsBaseController

  def find_or_create
    @object = Spree::CmsFile.new
    @collection = Spree::CmsFile.order('updated_at DESC')
    @search = @collection.ransack(params[:q])
    @collection = @search.result.page(params[:page]).per(10)
    respond_to do |format|
      format.html { render layout: 'spree/admin/layouts/iframe' }
      format.js { render layout: false }
    end
  end

  def submit_find_or_create
    @object = Spree::CmsFile.new
    invoke_callbacks(:create, :before)
    @object.attributes = params[object_name]
    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
      end
    else
      # ERROR
      invoke_callbacks(:create, :fails)
      @collection = Spree::CmsFile.order('updated_at DESC')
      @search = @collection.ransack
      @collection = @search.result.page(0).per(10)
      render :find_or_create, layout: 'spree/admin/layouts/iframe'
    end
  end

  private
  def location_after_save
    if params[:action] == 'submit_find_or_create'
      find_or_create_admin_cms_files_path
    else
      super
    end
  end

end
