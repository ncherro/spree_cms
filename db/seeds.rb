require 'factory_girl'
require 'spree_cms/factories'

reset_cms = true

if reset_cms
  Spree::Menu.delete_all
  Spree::MenuItem.delete_all

  Spree::Page.delete_all

  Spree::Layout.delete_all
  Spree::Region.delete_all
  Spree::Block.delete_all
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
  default = FactoryGirl.create(:layout_with_regions, name: 'Default')
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

  # add 3 levels of children to each menu item
  3.times do
    FactoryGirl.create(:menu_item_with_page, menu: main_menu, parent: main_menu_items.first)
    FactoryGirl.create(:menu_item_with_page, menu: utility_menu, parent: utility_menu_items.first)
    FactoryGirl.create(:menu_item_with_page, menu: footer_menu, parent: footer_menu_items.first)
  end

  exit



  # Main menu items
  fancy_list = [
    "oily, clogged pores, severe all-over breakouts",
    "oily, combination, occasional breakouts, anti-aging",
    "oily, combination, sensitive, consistent",
    "oily, combination, sensitive, occasional breakouts",
    "normal, sensitive, red, anti-aging",
    "normal, anti-aging",
    "dry, tired, aging",
    "dry, sun damaged, aging",
    "dry, sensitive, red, aging",
  ]
  skin_types = FactoryGirl.create(
    :page,
    title: 'One size does not fit all',
    slug: 'skin-types',
    menu_item_title: 'Skin Types',
    spree_menu_id: main_menu.id,
    layout: 'skin_types',
    render_layout_as_partial: true,
    body: %(<p>#{Faker::Lorem.paragraph}</p><ul class="fancy">#{fancy_list.each_with_index.map { |item, i| '<li><a href="#">Skin Type #' + (i + 1).to_s + '</a>' + item + '</li>'}.join("\n")}</ul><iframe src="//player.vimeo.com/video/74431122?badge=0&amp;color=ffffff" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe><p>#{Faker::Lorem.paragraph}</p><p>#{Faker::Lorem.paragraph}</p>)
  )

  (1..9).each do |n|
    skin_type = FactoryGirl.create(
      :page,
      title: "Skin Type ##{n}",
      slug: "skin-types/#{n}",
      spree_menu_id: main_menu.id,
      parent_id: skin_types.id,
      layout: 'skin_type',
      render_layout_as_partial: true
    )
    ["Basic", "Essential", "Complete"].each do |c|
      FactoryGirl.create(
        :page,
        title: "The #{c} Routine for Skin Type ##{n}",
        menu_item_title: c,
        slug: "skin-types/#{n}/#{c.downcase}",
        spree_menu_id: main_menu.id,
        parent_id: skin_type.id,
      )
    end
  end

  advice = FactoryGirl.create(:page, title: 'Advice', spree_menu_id: main_menu.id, foreign_link: 'http://www.wordpress.com')

  spas = FactoryGirl.create(:page, title: 'Spas', spree_menu_id: main_menu.id)

  about = FactoryGirl.create(:page, title: 'About', spree_menu_id: main_menu.id)


  # Footer menu items
  FactoryGirl.create(:page, title: 'Press', spree_menu_id: footer_menu.id)

  customer_service = FactoryGirl.create(:page, title: 'Customer Service', spree_menu_id: footer_menu.id)
  ["Return Policy", "Shipping", "Gift Cards", "FAQs"].each do |title|
    FactoryGirl.create(
      :page,
      title: title,
      slug: "#{customer_service.slug}/#{title.parameterize}",
      spree_menu_id: footer_menu.id,
      parent_id: customer_service.id,
    )
  end

  FactoryGirl.create(:page, title: 'Privacy & Terms', spree_menu_id: footer_menu.id)

end
