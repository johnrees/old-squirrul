FactoryGirl.define do

  factory :ebay_item do
    sequence(:name) { |n| "Test Auction #{n}" }
    ends_at { 2.hours.from_now }
    bid_price_cents { 99 }
    number_of_bids { 0.upto(50).to_a.sample }
  end

end
