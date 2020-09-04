class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.integer :stored_value
      t.references :card
      t.references :user
      t.timestamps null: false
    end
  end
end
