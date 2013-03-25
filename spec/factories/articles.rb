# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :article do
    title { Forgery(:lorem_ipsum).words(rand(3..10)) }
    content { Forgery(:lorem_ipsum).paragraphs(rand(2..5)) }
    status { Article::STATUSES.sample }
    association :user
    association :group
  end
end
