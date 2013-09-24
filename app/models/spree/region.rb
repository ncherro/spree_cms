class Spree::Region < ActiveRecord::Base

  belongs_to :layout, class_name: "Spree::Layout", foreign_key: "spree_layout_id"

  has_many :blocks_regions, class_name: "Spree::BlocksRegion",
    foreign_key: "spree_region_id", dependent: :destroy, order: :position
  has_many :blocks, class_name: "Spree::Block", through: :blocks_regions,
    dependent: :destroy

  attr_accessible :name, :template, :partial, :blocks_regions_attributes,
    :css_class, :css_id

  accepts_nested_attributes_for :blocks_regions, reject_if: :all_blank,
    allow_destroy: true
  validates_associated :blocks_regions

end
