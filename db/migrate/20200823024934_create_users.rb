class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.boolean :is_owner, default: false
      t.integer :balance, default: 0
      t.string :email
      t.references :shop
      t.string :name
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
