class AddNewsReportRefToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :news_reports, foreign_key: true
  end
end
