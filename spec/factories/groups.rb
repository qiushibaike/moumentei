# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :group do
    name 'test'
  end
  factory :team, :parent => :group do
    type "Team"
  end
  factory :series, :parent => :group do
    type "Series"
  end
end
