class Comment < ApplicationRecord
  belongs_to :profile
  belongs_to :news_report
  validates :comment, presence: true, length: {maximum: 2500, too_long: "%{count} characters are allowed"}
  validates :sentiment, presence: true
  validates :createdby, presence: true
end
