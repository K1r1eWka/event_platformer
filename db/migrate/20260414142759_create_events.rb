class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :starts_at
      t.string :location
      t.integer :duration_minutes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
