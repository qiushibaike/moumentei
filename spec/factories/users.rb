FactoryGirl.define do
  factory :user do
		password 'justtest'
		password_confirmation 'justtest'

		state 'pending'

  	sequence(:email) { |n| "test#{n}@test.com"}
  	sequence(:login) { |n| "justtest#{n}"}
  end
end