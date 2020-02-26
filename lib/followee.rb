class Followee
    def update(follower_id, followee_id)
        @current_profile = Profile.find(follower_id)
        @current_profile.follows.create(followee_id: followee_id)
    end
end