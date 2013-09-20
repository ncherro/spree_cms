class Spree::Menu < ActiveRecord::Base

  has_many :menu_blocks, class_name: "Spree::MenuBlock", dependent: :destroy

  attr_accessible :title

  validates :title, uniqueness: true, presence: true

end
