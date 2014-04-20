class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :quantity
      t.integer :line_item_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
