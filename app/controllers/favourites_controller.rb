class FavouritesController < ApplicationController
    def my_favourites
        @current_user = User.find(session["warden.user.user.key"][0][0])
        @current_profile = @current_user.profile
        @followees = @current_profile.follows
        @profiles = Array.new
        @followees.each do |followee|
            @news_reports = Profile.find(followee.followee_id).news_reports
            @profiles << @news_reports
        end
    end
end
