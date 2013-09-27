class Spree::BlocksRegion < ActiveRecord::Base

  validates :spree_block_id, presence: true

  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  # not sure why we need to do this...
  belongs_to :menu_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :html_block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :static_block, class_name: "Spree::Block", foreign_key: "spree_block_id"

  belongs_to :region, class_name: "Spree::Region", foreign_key: "spree_region_id"

  has_many :overrides, class_name: "Spree::BlocksRegionOverride",
    foreign_key: "spree_blocks_region_id", dependent: :destroy

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

  def override(page)
    if bro = Spree::BlocksRegionOverride.where(spree_page_id: page.id, spree_blocks_region_id: self.id).first
      if bro.spree_block_id.nil?
        # return nothing (we are hiding the block)
        nil
      else
        # override this
        self.spree_block_id = bro.spree_block_id
        self.template_override = bro.template_override
      end
    end
  end

end
