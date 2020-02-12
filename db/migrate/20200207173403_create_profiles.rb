class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :fname
      t.string :sname
      t.string :bio
      t.string :role

      t.timestamps
    end
  end
end
