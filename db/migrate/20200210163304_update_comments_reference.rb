class UpdateCommentsReference < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :report, :references
  end
end
