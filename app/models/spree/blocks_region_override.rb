class Spree::BlocksRegionOverride < ActiveRecord::Base

  belongs_to :blocks_region, class_name: "Spree::BlocksRegion",
    foreign_key: "spree_blocks_region_id"

  belongs_to :page, class_name: "Spree::Page", foreign_key: "spree_page_id"

  # we can override this stuff
  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  # not sure why we need to do this...
  belongs_to :menu_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :html_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :static_block, class_name: "Spree::Block", foreign_key: "spree_block_id"

  attr_accessible :spree_blocks_region_id, :spree_page_id, :template_override

  # ok if blank - '- Inherit -'
  #validates :spree_block_id, presence: true

  def template
    if self.template_override.present?
      self.template_override
    else
      # delegate doesn't seem to work - I assume b/c of STI
      self.block.template
    end
  end

end
