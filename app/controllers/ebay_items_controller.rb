class EbayItemsController < ApplicationController

  before_action :authorize

  def index
    @ebay_items = EbayItem.upcoming
    @snipes = Snipe.where(user: current_user)
  end

end
