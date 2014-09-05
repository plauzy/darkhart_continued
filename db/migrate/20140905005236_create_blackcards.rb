class CreateBlackcards < ActiveRecord::Migration
  def change
    create_table :blackcards do |t|
      t.text :content

      t.timestamps
    end
  end
end
