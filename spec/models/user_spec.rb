require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { create(:user, username: 'john') }

  it "is valid" do
    expect(build_stubbed(:user)).to be_valid
  end

  it "has secure_password" do
    expect(User).to respond_to(:has_secure_password)
  end

  it "validates uniqueness of username" do
    user # initialize :let object
    expect{
      create(:user, username: 'john')
    }.to raise_error(/Username has already been taken/)
  end

  it "has many snipes" do
    snipe = create(:snipe, user: user)
    expect(user.snipes).to eq([snipe])
  end

  it "can authenticate with ebay"

  it "can prepare a snipe"
  #   ebay_item = create(:ebay_item)
  #   # expect(user.snipes).to receive(:create).with("an argument I want")
  #   user.make_snipe(ebay_item, 100)
  # end

end
