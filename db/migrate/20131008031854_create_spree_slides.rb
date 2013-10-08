class CreateSpreeSlides < ActiveRecord::Migration
  def change
    create_table :spree_slides do |t|
      t.belongs_to :spree_block
      t.integer :position
      t.string :title
      t.string :url
      t.text :copy

      t.timestamps
    end
    add_index :spree_slides, :spree_block_id
  end
end
