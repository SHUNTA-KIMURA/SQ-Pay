class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :item
      t.references :user
      t.timestamps null: false
    end
  end
end
