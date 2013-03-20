FactoryGirl.define do
  factory :article do
    title 'test'
    content 'test'
    status 'publish'
    alt_score 5
    association :user
    association :group
  end
end
