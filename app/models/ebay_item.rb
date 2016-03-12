require 'open-uri'
require 'ebay_client'

class EbayItem < ApplicationRecord

  register_currency :gbp
  monetize :bid_price_cents
  has_many :snipes, dependent: :destroy

  scope :upcoming, -> { where('ends_at > ?', Time.now).order(ends_at: :asc) }

  after_save :push, if: :number_of_bids_changed?

  # def scrape_times
  #   times = [604800]
  #   while times.last > 2
  #     times.push (times.last * 0.75).to_i
  #   end
  #   puts times
  # end

  def state
    Time.now < ends_at ? 'active' : 'ended'
  end

  def self.extract_id _url
    _url = _url.to_s
    if match = _url.match(/(\d{12})/) #_url.match(/\D|\A(\d{12})\D|\z/)
      match[0].to_i
    else
      false
    end
  end

  def to_s
    name
  end

  def self.get _id
    item = find_or_initialize_by(id: _id)
    item.scrape!
    return item
  end

  def scrape
    response = EbayClient.new(url).scrape_auction
    self.name = response[:name] if response[:name]
    self.ends_at = response[:ends_at] if response[:ends_at]
    self.bid_price_cents = response[:bid_price_cents] if response[:bid_price_cents]
    self.number_of_bids = response[:number_of_bids] if response[:number_of_bids]
  end

  def scrape!
    scrape
    save!
  end

  def lite_scrape!
    response = EbayClient.new.lite_scrape(id)
    self.bid_price_cents = response[:bid_price_cents] if response[:bid_price_cents]
    self.number_of_bids = response[:number_of_bids] if response[:number_of_bids]
    save!
  end

  def url
    "http://www.ebay.co.uk/itm/#{id}"
  end

  def as_json options={}
    {
      name: name,
      current_bid_price: bid_price.to_f,
      ends: ends_at.to_s#.strftime("%d/%m/%y %H:%M:%S")
    }
  end

  def min_bid_price
    if number_of_bids == 0
      return bid_price
    else
      EbayItem.increments.reverse.each do |increment|
        if bid_price_cents/100.0 >= (increment[0])
          return Money.new(bid_price_cents + (increment[1] * 100), 'GBP')
        end
      end
    end
  end

private

  def self.increments
    [
      [0.01,0.05],
      [1.00,0.20],
      [5.00,0.50],
      [15.00,1.00],
      [60.00,2.00],
      [150.00,5.00],
      [300.00,10.00],
      [600.00,20.00],
      [1500.00,50.00],
      [3000.00,100.00]
    ]
  end

  def push
    MessageBus.publish "/items", {
      id: id,
      values: {
        number_of_bids: number_of_bids,
        bid_price: bid_price.to_s,
        min_bid_price: min_bid_price.to_s
      }
    }
  end

end
