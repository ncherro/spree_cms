class CreateSpreeBlocksRegions < ActiveRecord::Migration
  def change
    create_table :spree_blocks_regions do |t|
      t.belongs_to :spree_block
      t.belongs_to :spree_region

      t.integer :position

      t.timestamps
    end
    add_index :spree_blocks_regions, :spree_block_id
    add_index :spree_blocks_regions, :spree_region_id
  end
end