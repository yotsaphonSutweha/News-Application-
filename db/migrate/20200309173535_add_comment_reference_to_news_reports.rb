class AddCommentReferenceToNewsReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :news_reports, :comments, foreign_key: true
  end
end
