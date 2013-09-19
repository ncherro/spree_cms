class CreateSpreeBlocks < ActiveRecord::Migration
  def change
    create_table :spree_blocks do |t|
      t.string :name
      t.string :type
      t.string :template
      t.text :content

      t.timestamps
    end
  end
end
