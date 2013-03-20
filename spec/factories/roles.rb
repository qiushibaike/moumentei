FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "admin#{n}" }
  end
end