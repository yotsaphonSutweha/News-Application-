require 'open-uri'
require 'json'
require 'breaking_news_apis'

class NewsController < ApplicationController 
    def get_news
        begin
            @current_user = User.find(session["warden.user.user.key"][0][0])
            # Using the singleton design pattern, we use the instance of BreakingNewsAPIs to get the news
            @news = BreakingNewsApis.instance.get_news
            # Using the session, we get the previous search made by the user
            @previous_search = session[:previous_search]
            # If the previous search is not nil, we make the @recommended_news available for display on the UI
            if @previous_search != nil
                @recommended_news = BreakingNewsApis.instance.recommendation(@previous_search)
            end
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end

    def search_news 
        begin
            @current_user = User.find(session["warden.user.user.key"][0][0])
            @search_value = params[:search_value]
            # Using session, setting the previous_search with the user's latest search value
            session[:previous_search] = @search_value
            @news = BreakingNewsApis.instance.search(@search_value)
            # Also, we use NewsReport object to find any existing news reports within the database that contains the category matching the search_value
            @news_reports = NewsReport.where({ category: @search_value})
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end
end