require 'followee'
require 'follower_number'
require 'listener'
class FollowController < ApplicationController
    def following
        @current_user = User.find(session["warden.user.user.key"][0][0])
        @current_profile = @current_user.profile
        @followee_id = params[:following_id]
        @follower_id = @current_profile.id 
        @listener = Listener.new
        @followee_number = FollowerNumber.new
        @followee = Followee.new
        @listener.add_observer(@followee_number)
        @listener.add_observer(@followee)
        @listener.trigger_following(@follower_id, @followee_id)
        redirect_to newswriters_url(@current_user), flash: { alert: "Follow suucessful" }
    end
end