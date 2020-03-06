class UpdateCommentsTimestampsAgain < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :created_at, :datetime
    #Ex:- :null => false
    add_column :comments, :updated_at, :datetime
  end
end
