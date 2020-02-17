class AddCreatedbyToNewsReports < ActiveRecord::Migration[5.2]
  def change
    add_column :news_reports, :createdby, :string
  end
end
