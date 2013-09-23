class Spree::MenuItem < ActiveRecord::Base

  has_ancestry

  CACHE_PREFIX = 'spree_menu_items_'

  before_validation :set_cached_slug
  after_save :drop_cached_slug

  has_many :menu_blocks, class_name: "Spree::MenuBlock", dependent: :destroy

  has_one :page, class_name: "Spree::Page", foreign_key: "spree_menu_item_id"
  belongs_to :menu, class_name: "Spree::Menu", foreign_key: "spree_menu_id"

  attr_accessible :ancestry, :css_class, :css_id, :slug, :title,
    :spree_menu_id, :is_published, :is_visible_in_menu

  def slug
  end

  class << self

    def published
      where(is_published: true)
    end

    def id_by_cached_slug(cached_slug)
      Rails.cache.fetch("#{CACHE_PREFIX}#{cached_slug}") do
        slug = Cms.remove_spree_mount_point(cached_slug)
        menu_item = self.published.select('is_published, id').where(cached_slug: slug).first
        return menu_item ? menu_item.id : nil
      end
    end

  end

  private
  def set_cached_slug
    o_s = [self.parents.slugs, self.slug].join('/')
    s = o_s
    # if exists, then add -0
    i = 0
    while self.class.find_by_cached_slug(s)
      i += 1
      s = "#{o_s}-#{i}"
    end
    self.cached_slug = s
  end

  def drop_cached_slug
    if self.cached_slug_changed? || self.ancestry_changed? || self.is_published_changed?
      # remove the old value from our cache table
      Rails.cache.delete("#{CACHE_PREFIX}#{self.cached_slug_was}-exists")
      Rails.cache.delete("#{CACHE_PREFIX}#{self.cached_slug_was}")
    end
    true
  end

end
