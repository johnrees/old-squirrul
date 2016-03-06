class RenameEbayBidsToSnipes < ActiveRecord::Migration[5.0]
  def change
    rename_table :ebay_bids, :snipes
  end
end
