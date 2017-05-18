class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, uniqueness: true
      t.string :hashed_password, null: false
      t.string :email, null: false, uniqueness: true
      t.timestamps(null: false)
    end
    add_index :users, :email, :unique => true
  end
end
