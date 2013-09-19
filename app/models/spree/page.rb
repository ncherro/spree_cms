class Spree::Page < ActiveRecord::Base

  belongs_to :layout, class_name: "Spree::Layout"
  belongs_to :menu_item, class_name: "Spree::Page"

  attr_accessible :body, :meta_description, :meta_keywords, :meta_title,
    :is_published, :title

  delegate :template, to: :layout, allow_nil: true

end
