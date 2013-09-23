class Spree::Menu < ActiveRecord::Base

  has_many :menu_blocks, class_name: "Spree::MenuBlock",
    foreign_key: "spree_menu_id", dependent: :destroy
  has_many :menu_items, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_id", dependent: :destroy

  attr_accessible :title

  validates :title, uniqueness: true, presence: true

end
