class Spree::Slide < ActiveRecord::Base

  belongs_to :slideshow_block, class_name: "Spree::SlideshowBlock",
    foreign_key: "spree_block_id"

  attr_accessible :copy, :position, :title, :url, :image_attributes

  has_one :image, as: :imageable, class_name: "Spree::CmsImage"

  accepts_nested_attributes_for :image, reject_if: :all_blank,
    allow_destroy: false
  validates_associated :image

end
