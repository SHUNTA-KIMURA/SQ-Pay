class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :item
      t.references :user
      t.integer :count, default: 0
      t.timestamps null: false
    end
  end
end
