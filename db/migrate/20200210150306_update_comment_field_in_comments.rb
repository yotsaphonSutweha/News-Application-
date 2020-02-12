class UpdateCommentFieldInComments < ActiveRecord::Migration[5.2]
  def change
    change_column  :comments, :comment, :text
    change_column  :news_reports, :content, :text
  end
end
