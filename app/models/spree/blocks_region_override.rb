class Spree::BlocksRegionOverride < ActiveRecord::Base

  belongs_to :blocks_region, class_name: "Spree::BlocksRegion",
    foreign_key: "spree_blocks_region_id"

  belongs_to :page, class_name: "Spree::Page", foreign_key: "spree_page_id"


  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :menu_block, class_name: "Spree::Block",
    foreign_key: "spree_block_id"
  belongs_to :html_block, class_name: "Spree::Block",
    foreign_key: "spree_block_id"
  belongs_to :static_block, class_name: "Spree::Block",
    foreign_key: "spree_block_id"


  attr_accessible :spree_blocks_region_id, :spree_block_id, :spree_page_id,
    :template_override

  validates :spree_blocks_region_id, uniqueness: { scope: :spree_page_id }
  validates :spree_blocks_region_id, presence: true

  def template
    if self.template_override.present?
      self.template_override
    else
      self.blocks_region.template
    end
  end

  class << self
    def available_blocks
      Spree::Block.all.map { |b| [b.label_for_select, b.id] }
    end
  end

end
