# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :comment do
    content { Forgery(:lorem_ipsum).words(rand(2..30)) }
    anonymous false
    status { Comment::STATUSES.sample }
    association :article 
    association :user
  end
end
