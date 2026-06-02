class AddPaidPriceTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :paid_price, :decimal, precision: 10, scale: 2
  end
end
