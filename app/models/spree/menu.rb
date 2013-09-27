class Spree::Menu < ActiveRecord::Base

  has_many :menu_blocks, class_name: "Spree::MenuBlock",
    foreign_key: "spree_menu_id", dependent: :destroy
  has_many :menu_items, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_id", dependent: :destroy

  after_touch :touch_menu_blocks

  attr_accessible :title

  validates :title, uniqueness: true, presence: true

  def touch_menu_blocks
    # touch all menu blocks that follow the current item, plus any menu blocks
    # belonging to this menu
    (Spree::MenuBlock.follow_current.all + self.menu_blocks.all).each do |mb|
      mb.touch
    end
  end

end
