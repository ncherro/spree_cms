class CreateSpreeBlocks < ActiveRecord::Migration
  def change
    create_table :spree_blocks do |t|
      t.string :name
      t.string :type
      t.string :template
      t.text :content

      # stuff specific to menu blocks
      t.integer :menu_block_type
      t.belongs_to :spree_menu
      t.belongs_to :spree_menu_item

      t.timestamps
    end
    add_index :spree_blocks, :name
    add_index :spree_blocks, :spree_menu_id
    add_index :spree_blocks, :spree_menu_item_id
  end
end
