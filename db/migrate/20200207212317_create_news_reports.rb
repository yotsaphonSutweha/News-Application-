class CreateNewsReports < ActiveRecord::Migration[5.2]
  def change
    create_table :news_reports do |t|
      t.string :title
      t.string :category
      t.string :content
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
