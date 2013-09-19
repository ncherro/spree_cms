class CreateSpreePages < ActiveRecord::Migration
  def change
    create_table :spree_pages do |t|
      t.belongs_to :spree_layout
      t.belongs_to :spree_menu_item

      t.boolean :is_published

      t.string :title
      t.text :body

      t.string :meta_title
      t.string :meta_keywords
      t.string :meta_description

      t.timestamps
    end
    add_index :spree_pages, :spree_layout_id
    add_index :spree_pages, :spree_menu_item_id
  end
end
