FactoryGirl.define do
  factory :comment do
    content '你是个好孩子 嘻嘻'
    anonymous false
    status 'publish'
    article
    user
  end
end
