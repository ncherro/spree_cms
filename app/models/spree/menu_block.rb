class Spree::MenuBlock < Spree::Block

  TYPES = [
    ['Start at root of specified Menu', 1],
    ['Start at specified Menu Item', 2],
    ['Show siblings of "current" menu item', 3],
    ['Show children of "current" menu item', 4],
  ]

  TYPES_REQUIRING_MENU = [1, 2,]
  TYPES_REQUIRING_MENU_ITEM = [2,]

  before_save :unset_menu_and_menu_item

  belongs_to :menu, class_name: "Spree::Menu"
  belongs_to :menu_item, class_name: "Spree::MenuItem"

  attr_accessible :menu_block_type, :menu_id, :menu_item_id

  validates :menu_block_type, presence: true
  validates :menu_id, presence: true,
    if: Proc.new { |mb| Spree::MenuBlock::TYPES_REQUIRING_MENU.include?(mb.menu_block_type) }
  validates :menu_item_id, presence: true,
    if: Proc.new { |mb| Spree::MenuBlock::TYPES_REQUIRING_MENU_ITEM.include?(mb.menu_block_type) }
  validate :menu_item_belongs_to_menu,
    if: Proc.new { |mb| Spree::MenuBlock::TYPES_REQUIRING_MENU_ITEM.include?(mb.menu_block_type) }

  def menu_item_belongs_to_menu
    if self.menu_id.present? && self.menu_item_id.present?
      mi = Spree::MenuItem.select('menu_id, id').find(self.menu_item_id)
      if mi.menu_id != self.menu_id
        errors.add(:menu_item_id, "must belong to the selected Menu")
      end
    end
  end

  def fragment_cache_options(path, options={})
    # return a hash used by the fragment cacher
    # if this follows the current menu item, then the path is relevant
    options.merge({ path: Spree::CmsRoutes.remove_spree_mount_point(path) }) if self.follows_current?
    options
  end

  def follows_current?
    !TYPES_REQUIRING_MENU.include?(self.menu_block_type)
  end

  def shows_children?
    self.menu_block_type == TYPES.assoc('Show children of "current" menu item').last
  end

  private
  def unset_menu_and_menu_item
    unless TYPES_REQUIRING_MENU_ITEM.include?(self.menu_block_type)
      self.menu_item_id = nil
    end
    unless TYPES_REQUIRING_MENU.include?(self.menu_block_type)
      self.menu_id = nil
    end
    true
  end

end
