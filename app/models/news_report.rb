class NewsReport < ApplicationRecord
  belongs_to :profile
  has_many :comments
  validates :title, presence: true, length: { maximum: 100, too_long: "%{count}characters are allowed" }
  validates :category, presence: true
  validates :content, presence: true
  validates :createdby, presence: true
end
