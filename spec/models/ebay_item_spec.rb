require 'rails_helper'

RSpec.describe EbayItem, :type => :model do

  let(:ebay_item) { create(:ebay_item) }

  # it "can be created by item_id" do
  #   item = create(:ebay_item)
  #   expect( EbayItem.find_or_create_by_item_id(123) ).to eq(item)
  # end

  it "extracts an ebay ID from a url" do
    url = "http://www.ebay.co.uk/itm/Giant-200mm-Polystyrene-Cube-/301224088683?pt=UK_Crafts_Children_s_Crafts_EH&hash=item46225ad46b"
    expect(EbayItem.extract_id(url)).to eq(301224088683)
  end

  it "is valid" do
    expect(build_stubbed(:ebay_item)).to be_valid
  end

  it "uses GBP as default currency" do
    expect(build_stubbed(:ebay_item).bid_price.currency).to eq("GBP")
  end

  it "can be created with bid_price_cents" do
    expect(build_stubbed(:ebay_item,
      bid_price_cents: 344).bid_price.to_f).to eq(3.44)
  end

  it "can return bid_price_cents" do
    expect(build_stubbed(:ebay_item,
      bid_price: 0.21).bid_price_cents).to eq(21)
  end

  it "has upcoming scope" do
    ending_tomorrow = create(:ebay_item, ends_at: 1.day.from_now)
    ending_soon = create(:ebay_item, ends_at: 1.minute.from_now)
    ended = create(:ebay_item, ends_at: 1.minute.ago)
    expect(EbayItem.upcoming).to eq([ending_soon, ending_tomorrow])
  end

  it "pulls item from live site" do
    VCR.use_cassette("scrape-ebay-item") do
      item = EbayItem.get(172123348938)
      expect(item.name
        ).to eq("Pokemon SoulSilver Version for Nintendo DS and 3DS")
    end
  end

  it "has a url" do
    item = build_stubbed(:ebay_item, id: 456)
    expect(item.url).to eq("http://www.ebay.co.uk/itm/456")
  end

  it "has json response" do
    Timecop.freeze do
      ebay_item = build_stubbed(:ebay_item,
        name: 'test auction',
        bid_price: 2.99,
        ends_at: 1.day.from_now)

      expect(ebay_item.to_json).to eq({
        name: 'test auction',
        current_bid_price: 2.99,
        ends: 1.day.from_now.to_s
      }.to_json)
    end
  end

  describe "min_bid_price" do

    it "returns bid_price if no bids" do
      ebay_item = build_stubbed(:ebay_item, bid_price: 0.99, number_of_bids: 0)
      expect(ebay_item.min_bid_price.to_f).to eq(0.99)
    end

    it "returns higher figure than bid_price if bid already exists" do
      test_data = [
        [0.99, 1.04],
        [1.60, 1.80],
        [5.00, 5.50],
        [15.01, 16.01],
        [60.00, 62.00],
        [153, 158],
        [599.99, 609.99],
        [600.00, 620],
        [1520.33, 1570.33],
        [8523, 8623]
      ]
      test_data.each do |bid_price, expected_min_bid_price|
        ebay_item = build_stubbed(:ebay_item,
          bid_price: bid_price,
          number_of_bids: Random.new.rand(1..100)
        )
        expect(ebay_item.min_bid_price.to_f).to eq(expected_min_bid_price.to_f)
      end
    end

  end

end
