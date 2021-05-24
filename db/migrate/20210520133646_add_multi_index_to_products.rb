class AddMultiIndexToProducts < ActiveRecord::Migration[6.1]
  def change
    add_index :products, [:shop_id, :title]
    add_index :products, :title
    #Ex:- add_index("admin_users", "username")
  end
end
