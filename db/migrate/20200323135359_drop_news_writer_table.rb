class DropNewsWriterTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :news_writers
  end
end
