class Spree::Menu < ActiveRecord::Base

  has_many :menu_blocks, class_name: "Spree::MenuBlock",
    foreign_key: "spree_menu_id", dependent: :destroy
  has_many :menu_items, class_name: "Spree::MenuItem",
    foreign_key: "spree_menu_id", dependent: :destroy

  attr_accessible :title

  after_save :purge_cache!

  validates :title, uniqueness: true, presence: true

  # CACHING
  def cache_keys_key
    "spree_menu_#{self.id}"
  end

  def cache_cache_key(key)
    keys = Rails.cache.read(self.cache_keys_key) || []
    keys << key
    keys.uniq!
    Rails.cache.write(self.cache_keys_key, keys)
  end

  def purge_cache!
    keys = Rails.cache.read(self.cache_keys_key) || []
    keys.each do |key|
      Rails.cache.delete(key)
    end
    self.purge_cache_keys!
    true
  end

  def purge_cache_keys!
    # call this to invalidate any caches related to this menu
    Rails.cache.delete(self.cache_keys_key)
  end

  class << self
    def purge_caches
      Spree::Menu.all.each do |m|
        m.purge_cache!
      end
    end
  end

end
