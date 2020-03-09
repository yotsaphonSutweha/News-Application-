require 'open-uri'
require 'json'
require 'breaking_news_apis'

class NewsController < ApplicationController 
    def get_news
        begin
            @current_user = User.find(session["warden.user.user.key"][0][0])
            @news = BreakingNewsApis.instance.get_news
            @previous_search = session[:previous_search]
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
            session[:previous_search] = @search_value
            @news = BreakingNewsApis.instance.search(@search_value)
            @news_reports = NewsReport.where({ category: @search_value})
        rescue => exception
            redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
        end
    end
end