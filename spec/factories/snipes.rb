FactoryGirl.define do

  factory :snipe do
    association :ebay_item
    association :user
    max_amount { 500.00 }
  end

end
