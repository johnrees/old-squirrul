class AddNumberOfBidsToEbayItems < ActiveRecord::Migration[5.0]
  def change
    add_column :ebay_items, :number_of_bids, :integer, default: 0, null: false
  end
end
