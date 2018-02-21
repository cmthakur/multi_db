class CreateDatabases < ActiveRecord::Migration[5.1]
  def change
    create_table :databases do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
