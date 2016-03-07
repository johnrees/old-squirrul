require 'rails_helper'

RSpec.describe EbayItem, :type => :model do

  let(:ebay_item) { create(:ebay_item) }

  # it "can be created by item_id" do
  #   item = create(:ebay_item)
  #   expect( EbayItem.find_or_create_by_item_id(123) ).to eq(item)
  # end

  it "is valid" do
    expect(build_stubbed(:ebay_item)).to be_valid
  end

  end

  skip "has currency" do
    expect(build_stubbed(:ebay_item).currency).to eq("GBP")
  end

  skip "has bid_price" do
    expect(build_stubbed(:ebay_item, bid_price_cents: 344).bid_price).to eq(3.44)
  end

  skip "has bid_price_cents" do
    expect(build_stubbed(:ebay_item, bid_price: 0.21).bid_price).to eq(21)
  end

  it "pulls item from live site" do
    VCR.use_cassette("scrape-ebay-item") do
      item = EbayItem.get(172123348938)
      expect(item.name).to eq("Pokemon SoulSilver Version for Nintendo DS and 3DS")
    end
  end

  it "has a url" do
    item = build_stubbed(:ebay_item, id: 456)
    expect(item.url).to eq("http://www.ebay.co.uk/itm/456")
  end

end
