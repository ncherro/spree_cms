require 'factory_girl'
require 'spree_cms/factories'


reset_cms = true


if reset_cms
  Spree::Menu.delete_all
  Spree::MenuItem.delete_all
  Spree::Layout.delete_all
  Spree::Region.delete_all
  Spree::Block.delete_all
  Spree::Page.delete_all
  Spree::BlocksRegion.delete_all
end


if Spree::Menu.count.zero?
  main_menu = FactoryGirl.create(:menu, title: 'Main menu')
  utility_menu = FactoryGirl.create(:menu, title: 'Utility menu')
  footer_menu = FactoryGirl.create(:menu, title: 'Footer menu')
else
  main_menu = Spree::Menu.find_by_title('Main menu')
  utility_menu = Spree::Menu.find_by_title('Utility menu')
  footer_menu = Spree::Menu.find_by_title('Footer menu')
end


if Spree::Layout.count.zero?
  default = FactoryGirl.create(:default_layout)
else
  default = Spree::Layout.find_by_name('Default')
end


if Spree::MenuItem.count.zero?

  main_menu_items = []
  utility_menu_items = []
  footer_menu_items = []
  # add root menu items
  5.times do
    main_menu_items << FactoryGirl.create(:menu_item_with_page, menu: main_menu)
    utility_menu_items << FactoryGirl.create(:menu_item_with_page, menu: utility_menu)
    footer_menu_items << FactoryGirl.create(:menu_item_with_page, menu: footer_menu)
  end

  # nest
  3.times do
    parent = FactoryGirl.create(:menu_item_with_page, menu: main_menu, parent: main_menu_items.first)
    parent = FactoryGirl.create(:menu_item_with_page, menu: main_menu, parent: parent)
    FactoryGirl.create(:menu_item_with_page, menu: main_menu, parent: parent)

    FactoryGirl.create(:menu_item_with_page, menu: utility_menu, parent: utility_menu_items.first)
    FactoryGirl.create(:menu_item_with_page, menu: footer_menu, parent: footer_menu_items.first)
  end

end