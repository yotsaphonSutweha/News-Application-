class FavouritesController < ApplicationController
    def my_favourites
        begin
            @current_user = User.find(session["warden.user.user.key"][0][0])
            @current_profile = @current_user.profile
            @followees = @current_profile.follows
            @profiles = Array.new
            @followees.each do |followee|
                @news_reports = Profile.find(followee.followee_id).news_reports
                @profiles << @news_reports
            end
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end
end
