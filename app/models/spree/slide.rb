class Spree::Slide < ActiveRecord::Base

  belongs_to :slideshow_block, class_name: "Spree::SlideshowBlock",
    foreign_key: "spree_block_id"

  attr_accessible :copy, :position, :title, :url

  has_one :image, as: :imageable

  accepts_nested_attributes_for :image, reject_if: :all_blank,
    allow_destroy: true
  validates_associated :image

end
