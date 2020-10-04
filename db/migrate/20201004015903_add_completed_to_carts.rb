class AddCompletedToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :completed, :boolean
  end
end
