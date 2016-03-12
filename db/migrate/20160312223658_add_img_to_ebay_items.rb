class AddImgToEbayItems < ActiveRecord::Migration[5.0]
  def change
    add_column :ebay_items, :img, :string
  end
end
