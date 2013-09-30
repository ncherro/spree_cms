class Spree::Page < ActiveRecord::Base

  before_save :reset_body_cache


  belongs_to :layout, class_name: "Spree::Layout",
    foreign_key: "spree_layout_id"

  belongs_to :menu_item, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_item_id"

  has_many :blocks_region_overrides, class_name: "Spree::BlocksRegionOverride",
    foreign_key: "spree_page_id", dependent: :destroy


  accepts_nested_attributes_for :blocks_region_overrides, reject_if:
    :all_blank, allow_destroy: true
  validates_associated :blocks_region_overrides


  attr_accessible :title, :body, :meta_description, :partial_override,
    :meta_title, :meta_keywords, :spree_layout_id,
    :blocks_region_overrides_attributes, :body_cached


  delegate :template, :regions, to: :layout, allow_nil: true
  delegate :partial, to: :layout, prefix: true, allow_nil: true
  delegate :slug, to: :menu_item, allow_nil: true


  validates :title, presence: true


  # override the body reader
  def body
    if self.body_cached.nil?
      cached = Spree::CmsImage.replace_tokens(self.read_attribute(:body))
      self.update_column('body_cached', cached)
      cached
    else
      # return the cached body
      self.body_cached
    end
  end

  def partial
    self.partial_override.present? ? self.partial_override : self.template_partial
  end

  private
  def reset_body_cache
    self.body_cached = nil if self.body_changed?
    true
  end

end
