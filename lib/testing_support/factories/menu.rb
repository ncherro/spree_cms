FactoryGirl.define do
  factory :menu, class_name: "Spree::Menu" do
    title Faker::Lorem.word
  end
end
