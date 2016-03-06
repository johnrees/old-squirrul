class EbayItemsController < ApplicationController

  before_action :authorize

  def index
    @ebay_items = EbayItem.order(ends_at: :asc)
    @ebay_bids = EbayBid.where(user: current_user)
  end

end
