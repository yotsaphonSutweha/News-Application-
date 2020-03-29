class FavouritesController < ApplicationController
    def my_favourites
        begin
            # The current_user represents the logged in user
            @current_user = User.find(session["warden.user.user.key"][0][0])
            @current_profile = @current_user.profile
            # Get the current profile's followees (the other profiles that are being followed by the current profile)
            @followees = @current_profile.follows
            # Create a new array to store the news reports written by the followees
            @profiles = Array.new
            # Looping through the followees object and get the news reports associated with each followee
            @followees.each do |followee|
                @news_reports = Profile.find(followee.followee_id).news_reports
                @profiles << @news_reports
            end
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end
end
