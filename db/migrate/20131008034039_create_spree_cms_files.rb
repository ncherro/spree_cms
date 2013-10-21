class CreateSpreeCmsFiles < ActiveRecord::Migration
  def change
    create_table :spree_cms_files do |t|
      t.references :fileable, polymorphic: true

      t.string :file_uid
      t.string :file_name

      t.string :title
      t.string :name

      t.timestamps
    end
    add_index :spree_cms_files, [:fileable_type, :fileable_id]
  end
end
