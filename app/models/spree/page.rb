class Spree::Page < ActiveRecord::Base

  belongs_to :layout, class_name: "Spree::Layout",
    foreign_key: "spree_layout_id"

  belongs_to :menu_item, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_item_id"


  attr_accessible :title, :body, :meta_description, :partial_override,
    :meta_title, :meta_keywords, :spree_layout_id


  delegate :template, :regions, to: :layout, allow_nil: true
  delegate :partial, to: :layout, prefix: true, allow_nil: true
  delegate :slug, to: :menu_item, allow_nil: true


  validates :title, presence: true


  def partial
    self.partial_override.present? ? self.partial_override : self.template_partial
  end

end
