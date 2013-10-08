class Spree::SlideshowBlock < Spree::Block

  has_many :slides, class_name: "Spree::Slide",
    foreign_key: "spree_block_id", dependent: :destroy

  attr_accessible :slides_attributes

  accepts_nested_attributes_for :slides, reject_if: :all_blank,
    allow_destroy: true
  validates_associated :slides

end
