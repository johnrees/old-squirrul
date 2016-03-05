class CreateEbayItems < ActiveRecord::Migration[5.0]
  def change
    create_table :ebay_items do |t|
      t.integer :item_id
      t.string :name

      t.timestamps
    end
    add_index :ebay_items, :item_id
  end
end
