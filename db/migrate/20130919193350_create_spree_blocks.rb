class CreateSpreeBlocks < ActiveRecord::Migration
  def change
    create_table :spree_blocks do |t|
      t.string :name
      t.string :type
      t.string :template
      t.text :content

      # stuff specific to menu blocks
      t.integer :menu_block_type
      t.references :menu
      t.references :menu_item
      t.integer :max_levels, null: false, default: 0

      t.string :wrapper_el, null: false, default: ''
      t.string :item_wrapper_el, null: false, default: ''
      t.string :submenu_wrapper_el, null: false, default: ''

      t.timestamps
    end
    add_index :spree_blocks, :name
  end
end
