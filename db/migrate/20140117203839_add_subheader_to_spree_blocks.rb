class AddSubheaderToSpreeBlocks < ActiveRecord::Migration
  def change
    add_column :spree_blocks, :subheader, :string
  end
end
