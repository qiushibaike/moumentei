# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :rating do
    association :article
    association :user
    sequence( :score ){|n| n % 3 - 1 }
  end
end
