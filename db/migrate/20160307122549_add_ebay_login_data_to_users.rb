class AddEbayLoginDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ebay_login_data, :jsonb
  end
end
