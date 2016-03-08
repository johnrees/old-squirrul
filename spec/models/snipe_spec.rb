require 'rails_helper'

RSpec.describe Snipe, :type => :model do

  let(:user) { create(:user, username: 'steve', password: 'jobs') }
  let(:auction) { create(:ebay_item) }

  it "is valid" do
    expect(build_stubbed(:snipe)).to be_valid
  end

  it "can be assigned to a user and auction" do
    snipe = user.snipes.create(ebay_item: auction)
    expect(user.snipes).to eq([snipe])
  end

  it "can be created with an ebay url" do
    VCR.use_cassette("creating-snipe-with-url") do
      url = "http://www.ebay.co.uk/itm/Boxed-Nintendo-Wii-Super-Mario"\
            "-Galaxy-2-Game-With-Beginners-DVD-/391396734179?hash="\
            "item5b211034e3:g:KtYAAOSwuAVW1aeQ"
      expect(
        create(:snipe, ebay_item_input: url, ebay_item: nil).ebay_item.id
      ).to eq(391396734179)
    end
  end

  it "can be created for just watching an item"

  it "cannot be created, changed or removed within 30 seconds of closing"

  describe "states" do
    
    let(:ebay_item) { build_stubbed(:ebay_item, bid_price: 10) }

    it "is 'valid' if above the auction's current bid" do
      snipe = build_stubbed(:snipe, ebay_item: ebay_item, max_amount: 20)
      expect(snipe.state).to eq('valid')
    end

    it "is 'too_low' if below the auction's current bid" do
      snipe = build_stubbed(:snipe, ebay_item: ebay_item, max_amount: 5)
      expect(snipe.state).to eq('too_low')
    end

    it "is 'watching' if amount is nil" do
      snipe = build_stubbed(:snipe, ebay_item: ebay_item, max_amount: nil)
      expect(snipe.state).to eq('watching')
    end

    it "is changes to 'too_low' if item price goes higher than max_amount" do
      snipe = build_stubbed(:snipe, ebay_item: ebay_item, max_amount: 40)
      ebay_item.bid_price = 50
      expect(snipe.state).to eq('too_low')
    end

    it "notifies sniper if state changes from valid to too_low"

  end

end
