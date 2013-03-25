# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com"}
    sequence(:login) { |n| "justtest#{n}"}
		password { Forgery(:basic).password }
		password_confirmation { password }
		state 'pending'
  end
end
