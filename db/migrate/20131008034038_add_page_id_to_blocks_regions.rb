class AddPageIdToBlocksRegions < ActiveRecord::Migration
  def change
    add_column :spree_blocks_regions, :spree_page_id, :integer, null: false, default: 0
    add_index :spree_blocks_regions, :spree_page_id
  end
end
