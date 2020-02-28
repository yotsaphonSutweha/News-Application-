class RemoveForeignKeys < ActiveRecord::Migration[5.2]
  def change
    # remove_foreign_key :comments, column: :news_reports_id
    # remove_foreign_key :comments, column: :report_id
  end
end
