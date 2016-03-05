class User < ApplicationRecord
  has_secure_password
  validates_uniqueness_of :username
  has_many :ebay_bids
end
