class User < ApplicationRecord
  
  has_secure_password
  validates_uniqueness_of :username
  has_many :snipes, dependent: :destroy

  def make_snipe auction_id, max_amount = nil
    ebay_item = EbayItem.get(auction_id)
    snipes.create(ebay_item: ebay_item, max_amount: max_amount)
  end

end
