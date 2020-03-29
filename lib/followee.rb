# This class is another observer
class Followee
    # This method insert a new record to the follows table, a relationship between the followee and follower. 
    def update(follower_id, followee_id)
        @current_profile = Profile.find(follower_id)
        @current_profile.follows.create(followee_id: followee_id)
    end 
end