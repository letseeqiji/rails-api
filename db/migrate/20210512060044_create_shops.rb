class CreateShops < ActiveRecord::Migration[6.1]
  def change
    create_table :shops do |t|
      t.string :name, null:false, default:''
      t.index :name
      t.integer :products_count, null:false, default:0
      t.integer :orders_count, null:false, default:0

      t.timestamps
    end
  end
end
