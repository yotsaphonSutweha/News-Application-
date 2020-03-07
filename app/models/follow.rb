class Follow < ApplicationRecord
   belongs_to :profile
   validates :followee_id, presence: true
end
