require 'ebay_client'
require 'support/vcr_config'

RSpec.describe EbayClient do

  describe "placing a bid" do

    it "can bid on an ebay item" do
      VCR.use_cassette("successful-bid-on-an-ebay-item") do
        user = EbayClient.authenticate('ENV[ebay_user]', 'ENV[ebay_pass]')
        ebay_item_id = 222046535563
        bid_amount = "2.00"
        expect(
          EbayClient.bid!('baysushi', user[:cookies], user[:useragent],
            ebay_item_id, bid_amount)
        ).to be_truthy
      end
    end

  end

  describe "authenticating with ebay" do

    it "authenticates valid user" do
      VCR.use_cassette("authenticate-valid-user-with-ebay") do
        expect(EbayClient.authenticate('ENV[ebay_user]', 'ENV[ebay_pass]')).to be_truthy
      end
    end

    it "disallows invalid user" do
      VCR.use_cassette("authenticate-invalid-user-with-ebay") do
        expect(EbayClient.authenticate('ebayuser1298', 'pass1298')).to be_falsey
      end
    end

  end

end
