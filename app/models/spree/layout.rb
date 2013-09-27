class Spree::Layout < ActiveRecord::Base

  attr_accessible :name, :template, :partial, :regions_attributes

  validates :name, presence: true, uniqueness: true

  has_many :regions, class_name: "Spree::Region", foreign_key: "spree_layout_id"

  accepts_nested_attributes_for :regions, reject_if: :all_blank, allow_destroy: true
  validates_associated :regions

  def blocks_regions
    # this is used in the page blocks_region_overrides fields
    brs = []
    self.regions.each do |r|
      r.blocks_regions.map { |br| brs << ["#{r.name} - #{br.block.label_for_select}", br.id] }
    end
    brs
  end

end
