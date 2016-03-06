class EbayItemsController < ApplicationController

  before_action :authorize

  def index
    @ebay_items = EbayItem.upcoming
    @ebay_bids = EbayBid.where(user: current_user)
  end

end
