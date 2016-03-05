require 'open-uri'

class EbayItem < ApplicationRecord

  register_currency :gbp
  monetize :bid_price_cents
  has_many :ebay_bids

  def to_s
    name
  end

  def self.find_or_create_by_item_id _id
    find_or_create_by(id: _id)
  end

  def self.get _id
    item = find_or_initialize_by(id: _id)
    item.scrape!
    item
  end

  def scrape
    body = open(url).read
    begin
      self.name = body.match(/property="og:title" content="([^"]+)"/)[1]
      # self.name = body.match(/etafsharetitle="([^"]+)"/)[1]
      if time = body.match(/"endTime":(\d+)/)
        self.ends_at = Time.at(time[1].to_i/1000)
      end

      if match = body.match(/"bidPrice":"([^"]+)"/)
        self.bid_price_cents = match[1].gsub(/\D/, '').to_i
      end

      if match = body.match(/"bids":(\d+)/)
        self.number_of_bids = match[1].gsub(/\D/, '').to_i
      end
    rescue
      Rails.logger.info "ERROR FOR #{id}"
      File.write([Time.now.to_i, id, 'html'].join('.'), body)
    end
  end

  def scrape!
    scrape
    save!
  end

  def url
    "http://www.ebay.co.uk/itm/#{id}"
  end

  def as_json options={}
    {
      name: name,
      current_bid_price: bid_price.to_f,
      ends: ends_at#.strftime("%d/%m/%y %H:%M:%S")
    }
  end

  def min_bid_price
    if number_of_bids == 0
      return bid_price
    else
      EbayItem.increments.reverse.each do |increment|
        if bid_price_cents/100.0 > (increment[0])
          return Money.new(bid_price_cents + (increment[1] * 100), 'GBP')
        end
      end
    end
  end

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

end
