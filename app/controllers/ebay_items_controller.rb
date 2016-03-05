class EbayItemsController < ApplicationController

  before_action :authorize

  def index
    @ebay_items = EbayItem.all
  end

end
