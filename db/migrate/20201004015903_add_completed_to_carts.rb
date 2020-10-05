class AddCompletedToCarts < ActiveRecord::Migration[5.2]
  def change
<<<<<<< HEAD
    add_column :carts, :completed, :boolean, default: false
=======
    add_column :carts, :completed, :boolean
>>>>>>> 08121428cb7e04e50884c4f3135901651d26aae6
  end
end
