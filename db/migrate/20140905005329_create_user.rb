class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :game_id
      t.string :name, null: false, limit:30
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
