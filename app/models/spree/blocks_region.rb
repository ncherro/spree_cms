class Spree::BlocksRegion < ActiveRecord::Base

  validates :spree_block_id, presence: true

  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  # not sure why we need to do this...
  belongs_to :menu_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :html_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :static_block, class_name: "Spree::Block", foreign_key: "spree_block_id"

  belongs_to :region, class_name: "Spree::Region", foreign_key: "spree_region_id"

  attr_accessible :position, :spree_block_id, :spree_region_id,
    :template_override

  def template
    if self.template_override.present?
      self.template_override
    else
      # delegate doesn't seem to work - I assume b/c of STI
      self.block.template
    end
  end

end
