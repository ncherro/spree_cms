class Spree::Region < ActiveRecord::Base

  belongs_to :layout, class_name: "Spree::Region"

  has_many :blocks_regions, class_name: "Spree::BlocksRegion",
    dependent: :destroy, order: :position
  has_many :blocks, class_name: "Spree::Block", through: :blocks_regions,
    dependent: :destroy

  attr_accessible :name, :template, :blocks_attributes

  accepts_nested_attributes_for :blocks
  validates_associated :blocks

end
