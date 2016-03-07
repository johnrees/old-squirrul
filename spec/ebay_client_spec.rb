require 'ebay_client'
require 'support/vcr_config'

RSpec.describe EbayClient do

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
