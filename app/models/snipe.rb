class Snipe < ApplicationRecord

  belongs_to :user
  belongs_to :ebay_item

  register_currency :gbp
  monetize :max_amount_cents, allow_nil: true

  validates_presence_of :user
  validates_uniqueness_of :ebay_item, scope: :user
  validate :check_amount_is_enough

  validate :ebay_item_xor_ebay_item_input

  attr_accessor :ebay_item_input
  before_validation :assign_ebay_item, if: :ebay_item_input

  scope :upcoming, -> {
    joins(:ebay_item).merge(EbayItem.upcoming).includes(:ebay_item)
  }

  def state
    if max_amount_cents.blank?
      "watching"
    elsif max_amount >= ebay_item.min_bid_price
      "valid"
    else
      "too_low"
    end
  end

  def bid!
    raise "BID TOO HIGH?" if max_amount.to_f > 10
    EbayClient.bid!(
      user.username,
      user.ebay_login_data['cookies'],
      user.ebay_login_data['useragent'],
      ebay_item_id,
      max_amount.to_f
    )
    ebay_item.scrape!
  end

private

  def ebay_item_xor_ebay_item_input
    unless ebay_item.blank? ^ ebay_item_input.blank?
      errors.add(:base, "Specify either an ebay_item or ebay_item_input, not both")
    end
  end

  def check_amount_is_enough
    if state != 'watching' and max_amount < ebay_item.min_bid_price
      errors[:amount] << "Must be greater than" \
        " (#{ebay_item.min_bid_price})"
    end
  end

  def assign_ebay_item
    self.ebay_item = EbayItem.get(EbayItem.extract_id(ebay_item_input))
    self.ebay_item_input = nil
  end

end
