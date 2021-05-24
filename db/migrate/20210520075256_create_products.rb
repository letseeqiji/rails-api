class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title, null: false, default: ''
      t.integer :price, null: false, default:0
      t.integer :published, null:false, default:1
      t.integer :shop_id, null:false, default:0

      t.timestamps
    end
  end
end
