class EbayItem < ApplicationRecord
  
  def self.find_or_create_by_item_id _item_id
    find_or_create_by(item_id: _item_id)
  end

end
