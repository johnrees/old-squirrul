class EbayItemsController < ApplicationController

  def index
    @ebay_items = EbayItem.all
    render json: @ebay_items.map(&:as_json)#.map{|e| [e.id, e.item_id, e.name, e.url]}
  end

end
