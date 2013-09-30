class CreateSpreeCmsImages < ActiveRecord::Migration
  def change
    create_table :spree_cms_images do |t|
      t.references :imageable, polymorphic: true

      t.string :file_uid
      t.string :file_name

      t.string :alt
      t.string :name

      t.timestamps
    end
    add_index :spree_cms_images, [:imageable_type, :imageable_id]
  end
end
