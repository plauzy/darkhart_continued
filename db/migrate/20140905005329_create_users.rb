class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, limit:30
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
