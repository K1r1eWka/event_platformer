class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true, name: "unique_emails" }
      t.string :password_digest
      t.string :role
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
