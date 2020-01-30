class CreateNewsWriters < ActiveRecord::Migration[5.2]
  def change
    create_table :news_writers do |t|
      t.string :username
      t.string :password
      t.string :firstName
      t.string :secondName
      t.string :bio
      t.string :role

      t.timestamps
    end
  end
end
