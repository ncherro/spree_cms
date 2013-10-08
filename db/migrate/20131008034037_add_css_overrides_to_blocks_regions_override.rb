class AddCssOverridesToBlocksRegionsOverride < ActiveRecord::Migration
  def change
    add_column :spree_blocks_region_overrides, :css_id_override, :string
    add_column :spree_blocks_region_overrides, :css_class_override, :string
  end
end
