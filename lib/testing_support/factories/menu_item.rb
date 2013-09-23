FactoryGirl.define do
  factory :menu_item, class_name: "Spree::MenuItem" do
    title Faker::Lorem.word
  end
end

