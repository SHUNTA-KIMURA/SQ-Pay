class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits do |t|
      t.integer :column_name
      t.integer :credit_number
      t.string :security_number
      t.string :expiration_date
      t.references :user
      t.timestamps null: false
    end

  end
end
