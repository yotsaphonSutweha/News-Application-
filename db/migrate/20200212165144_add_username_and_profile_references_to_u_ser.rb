class AddUsernameAndProfileReferencesToUSer < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_reference :users, :profile, foreign_key: true
  end
end
