class CreateSpreeMenus < ActiveRecord::Migration
  def change
    create_table :spree_menus do |t|
      t.string :title

      t.timestamps
    end
  end
end
