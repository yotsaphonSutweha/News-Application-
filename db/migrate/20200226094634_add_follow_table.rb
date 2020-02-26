class AddFollowTable < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.string :followee_id
      t.references :profile, foreign_key: true
      t.timestamps
    end
  end
end
