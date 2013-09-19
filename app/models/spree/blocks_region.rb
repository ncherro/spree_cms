class Spree::BlocksRegion < ActiveRecord::Base

  belongs_to :block, class_name: "Spree::Block"
  belongs_to :region, class_name: "Spree::Region"

  attr_accessible :position

end
