class Spree::Page < ActiveRecord::Base

  belongs_to :layout, class_name: "Spree::Layout",
    foreign_key: "spree_layout_id"

  belongs_to :menu_item, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_item_id"

  attr_accessible :body, :meta_description, :meta_keywords, :meta_title,
    :is_published, :title, :menu_item_attributes, :spree_layout_id

  accepts_nested_attributes_for :menu_item, allow_destroy: true,
    reject_if: :all_blank, update_only: true
  validates_associated :menu_item

  delegate :template, to: :layout, allow_nil: true
  delegate :slug, to: :menu_item, allow_nil: true

  validates :title, presence: true

end
