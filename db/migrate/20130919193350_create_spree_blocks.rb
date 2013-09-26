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

      t.timestamps
    end
    add_index :spree_blocks, :name
  end
end
