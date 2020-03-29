# One of the observers that is associated with the profile following functionality
class FollowerNumber
    # It updates the number of followers the followee has by adding one to the exixting followers number. 
    def update(follower_id, followee_id)
        @followee_profile = Profile.find(followee_id)
        @current_number = @followee_profile.no_of_followers
        @new_number = @current_number + 1
        @followee_profile.no_of_followers = @new_number
        @followee_profile.save
    end
end