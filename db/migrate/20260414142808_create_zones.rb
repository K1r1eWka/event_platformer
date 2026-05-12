class CreateZones < ActiveRecord::Migration[8.1]
  def change
    create_table :zones do |t|
      t.string :name
      t.integer :capacity
      t.decimal :price, precision: 10, scale: 2
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
