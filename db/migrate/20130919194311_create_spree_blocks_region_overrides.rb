class CreateSpreeBlocksRegionOverrides < ActiveRecord::Migration
  def change
    create_table :spree_blocks_region_overrides do |t|
      t.belongs_to :spree_blocks_region
      t.belongs_to :spree_page

      t.string :template_override

      t.timestamps
    end
    add_index :spree_blocks_region_overrides, :spree_blocks_region_id
    add_index :spree_blocks_region_overrides, :spree_page_id
  end
end
