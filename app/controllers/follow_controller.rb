require 'followee'
require 'follower_number'
require 'listener'
class FollowController < ApplicationController
    def following
        begin
            @current_user = User.find(session["warden.user.user.key"][0][0])
            @current_profile = @current_user.profile
            @followee_id = params[:following_id]
            @follower_id = @current_profile.id 
            # Instantiate the listener object within the observer pattern
            @listener = Listener.new
            # Instantiate the @follower_number object, one of the observers
            @follower_number = FollowerNumber.new
            # Instantiate abother observer
            @followee = Followee.new
            # Add the observers to the listener
            @listener.add_observer(@follower_number)
            @listener.add_observer(@followee)
            # The listener notifies the observers that the current_user has made a new profile following
            @listener.trigger_following(@follower_id, @followee_id)
            redirect_to newswriters_url(@current_user), flash: { alert: "Follow successful" }
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end
end