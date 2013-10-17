class Spree::Block < ActiveRecord::Base
  include Spree::CmsConcerns::PartialPathFix

  attr_accessible :content, :name, :template

  has_many :blocks_regions, class_name: "Spree::BlocksRegion",
    foreign_key: "spree_block_id", dependent: :destroy

  has_many :blocks_region_overrides, class_name: "Spree::BlocksRegionOverride",
    foreign_key: "spree_block_id", dependent: :destroy


  validates :name, presence: true

  validates :template, format: { with: /\A\w+\z/ }, allow_blank: true

  def label_for_select
    "#{self.class.name.demodulize.titleize} - #{self.name}"
  end

end
