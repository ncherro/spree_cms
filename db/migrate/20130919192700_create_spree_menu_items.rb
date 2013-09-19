class CreateSpreeMenuItems < ActiveRecord::Migration
  def change
    create_table :spree_menu_items do |t|
      t.belongs_to :spree_menu

      t.string :title
      t.string :css_id
      t.string :css_class
      t.integer :position
      t.string :slug

      t.timestamps
    end
    add_index :spree_menu_items, :spree_menu_id
  end
end
