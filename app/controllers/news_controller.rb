require 'open-uri'
require 'json'
require 'breaking_news_apis'

class NewsController < ApplicationController 
    def get_news
        @news = BreakingNewsApis.instance.get_news
        @previous_search = session[:previous_search]
        if @previous_search != nil
            @recommended_news = BreakingNewsApis.instance.recommendation(@previous_search)
        end
    end

    def search_news 
        @search_value = params[:search_value]
        session[:previous_search] = @search_value
        @news = BreakingNewsApis.instance.search(@search_value)
        @news_reports = NewsReport.where({ category: @search_value})
    end
end