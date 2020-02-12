class Profile < ApplicationRecord
    belongs_to :user
    has_many :news_reports
    validates :fname, presence: true
    validates :sname, presence: true
    validates :bio, presence: true, length: { maximum: 1000, too_long: "%{count} characters are allowed" }
    validates :role, presence: true
end
