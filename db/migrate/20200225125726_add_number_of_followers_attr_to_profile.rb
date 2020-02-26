class AddNumberOfFollowersAttrToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :no_of_followers, :int
  end
end
