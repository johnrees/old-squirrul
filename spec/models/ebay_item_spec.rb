require 'rails_helper'

RSpec.describe EbayItem, :type => :model do

  it "can be created by item_id" do
    item = EbayItem.create(id: 123)
    expect( EbayItem.find_or_create_by_item_id(123) ).to eq(item)
  end

  it "can be found by item_id" do
    expect( EbayItem.find_or_create_by_item_id(123).id ).to eq(123)
  end

  skip "has currency" do
    expect(EbayItem.new(bid_price: 2.99).currency).to eq("GBP")
  end

  skip "has bid_price" do
    expect(EbayItem.new(bid_price_cents: 344).bid_price).to eq(3.44)
  end

  skip "has bid_price_cents" do
    expect(EbayItem.new(bid_price: 0.21).bid_price).to eq(21)
  end

  it "pulls item from live site" do
    VCR.use_cassette("scrape-ebay-item") do
      item = EbayItem.get(172123348938)
      expect(item.name).to eq("Pokemon SoulSilver Version for Nintendo DS and 3DS")
    end
  end

  it "has a url" do
    item = EbayItem.new(id: 172123348938)
    expect(item.url).to eq("http://www.ebay.co.uk/itm/172123348938")
  end

end
