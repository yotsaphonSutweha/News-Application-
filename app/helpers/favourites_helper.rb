require 'date'
require 'time'
module FavouritesHelper
    def calculate_posted_hours(time)
        now = (Time.parse(DateTime.now.to_s) - Time.parse(time.to_s)) / 60
        posted_time = ''
        
        if (now.round(0) / 60) == 0
            posted_time = 'posted: ' + now.round(0).to_s + ' minutes ago'
        elsif (now.round(0) / 60) >= 1 && (now.round(0)/60) < 24
            if (now.round(0) / 60) == 1
                posted_time = 'posted: ' + (now.round(0) / 60).to_s + ' hour ago'
            else
                posted_time = 'posted: ' + (now.round(0) / 60).to_s + ' hours ago'
            end
        elsif (now.round(0)/60) > 24
            posted_time = 'posted: ' + ((now.round(0)/60)/24).to_s + ' days ago'
        end
        return posted_time 
    end
end
