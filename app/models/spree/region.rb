class Spree::Region < ActiveRecord::Base
  include Spree::CmsConcerns::PartialPathFix

  belongs_to :layout, class_name: "Spree::Layout", foreign_key: "spree_layout_id"

  has_many :blocks_regions, class_name: "Spree::BlocksRegion",
    foreign_key: "spree_region_id", dependent: :destroy, order: :position,
    conditions: { spree_page_id: 0 }

  has_many :blocks, class_name: "Spree::Block", through: :blocks_regions,
    dependent: :destroy
  has_many :html_blocks, class_name: "Spree::HtmlBlock",
    through: :blocks_regions, dependent: :destroy
  has_many :menu_blocks, class_name: "Spree::MenuBlock",
    through: :blocks_regions, dependent: :destroy
  has_many :slideshow_blocks, class_name: "Spree::SlideshowBlock",
    through: :blocks_regions, dependent: :destroy
  has_many :static_blocks, class_name: "Spree::StaticBlock",
    through: :blocks_regions, dependent: :destroy

  attr_accessible :name, :template, :partial, :blocks_regions_attributes,
    :css_class, :css_id

  accepts_nested_attributes_for :blocks_regions, reject_if: :all_blank,
    allow_destroy: true
  validates_associated :blocks_regions

  validates :name, uniqueness: {
    scope: :spree_layout_id,
    message: "has already been used in this Layout"
  }

  def page_blocks(page)
    # block_regions, with overrides
    brs = self.blocks_regions.map do |blocks_region|
      blocks_region.override(page)
    end.compact
    # page-specific block_regions
    page_blocks = page.blocks_regions.where(spree_region_id: self.id)
    brs += page_blocks
    if page_blocks.any?
      brs.sort! { |a, b| a.position.to_i <=> b.position.to_i }
    end
    brs
  end

end
