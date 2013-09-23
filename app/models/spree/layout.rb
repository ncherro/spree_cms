class Spree::Layout < ActiveRecord::Base

  attr_accessible :name, :template, :regions_attributes

  validates :name, presence: true, uniqueness: true

  has_many :regions, class_name: "Spree::Region", foreign_key: "spree_layout_id"

  accepts_nested_attributes_for :regions, reject_if: :all_blank, allow_destroy: true
  validates_associated :regions

end
