FactoryGirl.define do

  factory :menu, class: Spree::Menu do
    title 'Main menu'
  end

  factory :menu_item, class: Spree::MenuItem do
    title { Faker::Lorem.words(2).join(' ').capitalize }
    parent_id nil
    position 0

    is_published true
    is_visible_in_menu true

    factory :menu_item_with_page do
      association :page, factory: :page_with_default_layout
    end
  end

  factory :page, class: Spree::Page do
    meta_keywords { Faker::Lorem.words(10).join(' ') }
    meta_description { Faker::Lorem.words(10).join(' ') }
    meta_title { Faker::Lorem.words(2).join(' ').capitalize }

    title { Faker::Lorem.words(5).join(' ').capitalize }
    body { Faker::Lorem.paragraphs.map { |p| "<p>#{p}</p>" }.join("\n") }

    layout

    factory :page_with_default_layout do
      # always use the default layout
      layout factory: :default_layout
    end
  end


  factory :layout, class: Spree::Layout do
    name { Faker::Lorem.words(2).join(' ').capitalize }

    factory :layout_with_regions do
      factory :default_layout do
        name 'Default'
      end

      after(:create) do |layout|
        if layout.regions.empty?
          FactoryGirl.create(:region_with_blocks, name: 'Sidebar', layout: layout)
          FactoryGirl.create(:region_with_blocks, name: 'Content', layout: layout)
          FactoryGirl.create(:region_with_blocks, name: 'Sidebar right', layout: layout)
        end
      end
    end

    initialize_with { Spree::Layout.find_or_create_by_name(name) }
  end

  factory :menu_block, class: Spree::MenuBlock do
    name Faker::Lorem.words(2).join(' ').capitalize

    # this, along with lazy name ensures we only create 1 MenuBlock
    initialize_with { Spree::MenuBlock.find_or_create_by_name(name) }
  end

  factory :static_block, class: Spree::StaticBlock do
    name 'Page body'
    template 'page_body'

    # this, along with lazy name ensures we only create 1 StaticBlock
    initialize_with { Spree::StaticBlock.find_or_create_by_template(template) }
  end

  factory :html_block, class: Spree::HtmlBlock do
    name Faker::Lorem.words(2).join(' ').capitalize
    content { Faker::Lorem.paragraphs(1).map { |p| "<p>#{p}</p>" }.join("\n") }

    # this, along with lazy name ensures we only create 1 HtmlBlock
    initialize_with { Spree::HtmlBlock.find_or_create_by_name(name) }
  end

  factory :blocks_region, class: Spree::BlocksRegion do
    factory :br_menu_block do
      menu_block
    end
    factory :br_html_block do
      html_block
    end
    factory :br_static_block do
      static_block
    end
  end

  factory :region, class: Spree::Region do
    name Faker::Lorem.word

    factory :region_with_blocks do
      after(:create) do |region|
        FactoryGirl.create(:br_html_block, region: region)
        FactoryGirl.create(:br_static_block, region: region)
        #FactoryGirl.create(:br_menu_block, region: region)
      end
    end
  end

end
