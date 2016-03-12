class Admin::EbayItemsController < Admin::AdminController

  def index
    @ebay_items = EbayItem.order(ends_at: :asc)
  end

end
