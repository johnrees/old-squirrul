require 'rails_helper'

RSpec.describe EbayItem, :type => :model do

  it "can be created by item_id" do
    item = EbayItem.create(item_id: 123)
    expect( EbayItem.find_or_create_by_item_id(123) ).to eq(item)
  end

  it "can be found by item_id" do
    expect( EbayItem.find_or_create_by_item_id(123) ).to eq(
      EbayItem.where(item_id: 123).first
    )
  end

end
