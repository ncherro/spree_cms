class Spree::BlocksRegion < ActiveRecord::Base
  include Spree::CmsConcerns::PartialPathFix

  validates :spree_block_id, presence: true

  belongs_to :region, class_name: "Spree::Region", foreign_key: "spree_region_id"

  belongs_to :page, class_name: "Spree::Page", foreign_key: "spree_page_id"

  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :menu_block, class_name: "Spree::MenuBlock",
    foreign_key: "spree_block_id"
  belongs_to :html_block, class_name: "Spree::HtmlBlock",
    foreign_key: "spree_block_id"
  belongs_to :static_block, class_name: "Spree::StaticBlock",
    foreign_key: "spree_block_id"
  belongs_to :slideshow_block, class_name: "Spree::SlideshowBlock",
    foreign_key: "spree_block_id"

  has_many :overrides, class_name: "Spree::BlocksRegionOverride",
    foreign_key: "spree_blocks_region_id", dependent: :destroy

  attr_accessible :position, :spree_block_id, :spree_region_id,
    :template_override, :css_class, :css_id

  # TODO: validations?

  def override(page)
    self.block.template = self.template_override if self.template_override.present?
    if self.spree_page_id.blank? && bro = Spree::BlocksRegionOverride.where(spree_page_id: page.id, spree_blocks_region_id: self.id).first
      if bro.spree_block_id.nil?
        nil # return nothing (we are hiding the block)
      else
        # override
        self.spree_block_id = bro.spree_block_id
        if bro.template.present? && !self.template_override.present?
          self.block.template = bro.template
        end
      end
    else
      # there is no override
      self
    end
  end

end
