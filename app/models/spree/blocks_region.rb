class Spree::BlocksRegion < ActiveRecord::Base

  validates :block_id, :region_id, presence: true

  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :region, class_name: "Spree::Region", foreign_key: "spree_region_id"

  attr_accessible :position

end
