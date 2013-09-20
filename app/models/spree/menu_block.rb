class Spree::MenuBlock < Spree::Block

  attr_accessible :menu_block_type, :menu_id, :menu_item_id, :max_levels,
    :menu_wrap, :menu_item_wrap

  TYPES = [
    ['Full', 1],
    ['Descendents', 2],
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
