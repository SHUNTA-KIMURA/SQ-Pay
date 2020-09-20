class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :total
      t.boolean :completed, default: false
      t.references :user
      t.timestamps null: false
    end
  end
end
