class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest
      t.string :role, default: "member", null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
