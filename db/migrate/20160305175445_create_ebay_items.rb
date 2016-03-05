class CreateEbayItems < ActiveRecord::Migration[5.0]
  def change
    create_table :ebay_items do |t|
      t.string :name
      t.datetime :ends_at
      t.integer :bid_price_cents
      t.timestamps
    end
    change_column :ebay_items, :id, :bigint
  end
end
