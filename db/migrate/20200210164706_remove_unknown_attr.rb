class RemoveUnknownAttr < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :news_report_id
  end
end
