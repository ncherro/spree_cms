class CreateSpreeRegions < ActiveRecord::Migration
  def change
    create_table :spree_regions do |t|
      t.belongs_to :spree_layout

      t.string :name
      t.string :template

      t.timestamps
    end
    add_index :spree_regions, :spree_layout_id
  end
end
