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

  describe "states" do
    
    it "is valid if above the auction's minimum price"

  end

end
