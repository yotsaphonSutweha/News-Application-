class Comments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :comment
      t.string :createdby
      t.string :sentiment
      t.references :profile, foreign_key: true
      t.references :news_report, foreign_key: true
    end
  end
end
