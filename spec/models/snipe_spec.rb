require 'rails_helper'

RSpec.describe Snipe, :type => :model do

  it "can be assigned to a user and auction" do
    user = User.create(username: 'steve', password: 'jobs')
    auction = EbayItem.create(id: 100, bid_price_cents: 99)
    snipe = user.snipes.create(ebay_item: auction)
    expect(user.snipes).to eq([snipe])
  end

end
