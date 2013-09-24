class Spree::BlocksRegion < ActiveRecord::Base

  validates :spree_block_id, presence: true

  belongs_to :block, class_name: "Spree::Block", foreign_key: "spree_block_id"
  belongs_to :region, class_name: "Spree::Region", foreign_key: "spree_region_id"

  attr_accessible :position, :spree_block_id, :spree_region_id,
    :template_override

  delegate :template, to: :block, allow_nil: true

  def template
    self.template_override.present? ? self.template_override : self.template
  end

end
