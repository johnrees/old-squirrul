class Snipe < ApplicationRecord

  belongs_to :user
  belongs_to :ebay_item

  register_currency :gbp
  monetize :max_amount_cents

  validates_presence_of :user, :ebay_item
  validates_uniqueness_of :user, scope: :ebay_item
  validate :check_amount_is_enough

  def to_s
    [max_amount, state]
  end

  def state
    if max_amount_cents == 0
      "watching"
    elsif max_amount >= ebay_item.min_bid_price
      "valid"
    else
      "invalid"
    end
  end

private

  def check_amount_is_enough
    unless (max_amount || Money.new(0)) >= ebay_item.min_bid_price
      errors[:amount] << "Must be greater than" \
        " (#{ebay_item.min_bid_price})"
    end
  end

end
