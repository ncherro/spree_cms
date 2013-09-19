class Spree::MenuItem < ActiveRecord::Base

  has_one :page, class_name: "Spree::Page"
  belongs_to :menu, class_name: "Spree::Menu"

  attr_accessible :css_class, :css_id, :position, :slug, :title

  class << self

    def visible
      # TODO: think about this - should we move it to the Pages table?
      #where(visible: true)
      where('1 = 1')
    end

    def by_slug(slug)
      slug = Cms.remove_spree_mount_point(slug)
      menu_items = self.arel_table
      query = menu_items[:slug].eq(slug).or(menu_items[:slug].eq("/#{slug}"))
      self.where(query)
    end

  end

end
