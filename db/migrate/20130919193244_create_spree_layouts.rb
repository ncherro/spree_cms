class CreateSpreeLayouts < ActiveRecord::Migration
  def change
    create_table :spree_layouts do |t|

      t.string :name
      t.string :template

      t.timestamps
    end
  end
end
