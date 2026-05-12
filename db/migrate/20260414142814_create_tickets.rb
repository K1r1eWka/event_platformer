class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :zone, null: false, foreign_key: true
      t.string :status, default: "reserved"

      t.timestamps
    end
  end
end
