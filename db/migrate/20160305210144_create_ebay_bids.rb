class CreateEbayBids < ActiveRecord::Migration[5.0]
  def change
    create_table :ebay_bids do |t|
      t.integer :user_id
      t.bigint :ebay_item_id
      t.integer :max_amount_cents

      t.timestamps
    end
    add_index :ebay_bids, [:user_id, :ebay_item_id], unique: true
    add_foreign_key :ebay_bids, :ebay_items
    add_foreign_key :ebay_bids, :users
  end
end
