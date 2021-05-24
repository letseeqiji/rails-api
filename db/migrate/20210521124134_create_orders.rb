class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false, default:0
      t.integer :price_total, null: false, default:0

      t.timestamps
    end
  end
end
