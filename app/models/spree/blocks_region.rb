class Spree::BlocksRegion < ActiveRecord::Base

  validates :block_id, :region_id, presence: true

  belongs_to :block, class_name: "Spree::Block"
  belongs_to :region, class_name: "Spree::Region"

  attr_accessible :position

end
