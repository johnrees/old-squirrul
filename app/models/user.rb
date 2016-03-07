class User < ApplicationRecord
  
  has_secure_password
  validates_uniqueness_of :username
  has_many :snipes, dependent: :destroy

  def make_snipe auction_id, max_amount = 0
    ebay_item = EbayItem.get(auction_id)
    snipes.create(ebay_item: ebay_item, max_amount: max_amount)
  end

  def self.ebay_authenticate ebay_username, ebay_password
    if login_data = EbayClient.authenticate(ebay_username, ebay_password)
      User.find_or_initialize_by(username: ebay_username).tap do |user|
        user.password = ebay_password
        user.ebay_login_data = login_data
        user.save
      end
    else
      false
    end
  end

end
