class CreateSpreeMenuItems < ActiveRecord::Migration
  def change
    create_table :spree_menu_items do |t|
      t.belongs_to :spree_menu

      t.string :title
      t.string :css_id
      t.string :css_class
      t.string :slug
      t.string :cached_slug # full path to this page

      t.boolean :is_published
      t.boolean :is_visible_in_menu

      t.string :ancestry

      t.timestamps
    end
    add_index :spree_menu_items, :spree_menu_id
    add_index :spree_menu_items, :cached_slug
    add_index :spree_menu_items, :is_published
    add_index :spree_menu_items, :is_visible_in_menu
    add_index :spree_menu_items, :ancestry
  end
end
