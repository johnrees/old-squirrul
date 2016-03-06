FactoryGirl.define do

  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:password) { |n| "password" }
  end

end
