class Spree::Layout < ActiveRecord::Base

  attr_accessible :name, :template, :regions_attributes

  validates :name, presence: true, uniqueness: true

  has_many :regions

  accepts_nested_attributes_for :regions, reject_if: :all_blank, allow_destroy: true
  validates_associated :regions

end
