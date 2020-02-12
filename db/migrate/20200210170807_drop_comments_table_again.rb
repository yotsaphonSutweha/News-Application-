class DropCommentsTableAgain < ActiveRecord::Migration[5.2]
  def change
    drop_table :comments_tables
  end
end
