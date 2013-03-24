FactoryGirl.define do
  factory :anonymous_rating do
    article
    sequence( :score ){|n| n % 3 - 1 }
  end
end