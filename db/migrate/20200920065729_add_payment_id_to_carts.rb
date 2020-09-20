class AddPaymentIdToCarts < ActiveRecord::Migration[5.2]
  def change
    add_reference :carts, :payment, index: true
  end
end
