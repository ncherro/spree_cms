class Spree::MenuBlock < Spree::Block

  belongs_to :menu, class_name: "Spree::Menu"
  belongs_to :menu_item, class_name: "Spree::MenuItem"

  attr_accessible :menu_block_type, :menu_id, :menu_item_id, :max_levels,
    :menu_wrap, :menu_item_wrap

  TYPES = [
    ['Start at root', 1],
    ['Start at specified menu item', 2],
    ['Show siblings of current menu item', 3],
    ['Show children of current menu item', 4],
  ]

  MENU_WRAP_OPTIONS = [
    ['none', 0],
    ['ul', 1],
    ['ol', 2],
  ]

  MENU_ITEM_WRAP_OPTIONS = [
    ['none', 0],
    ['li', 1],
  ]

end
