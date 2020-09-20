class CreateUserPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_payments do |t|
      t.references :user
      t.references :payment
      t.timestamps null: false
    end
  end
end
