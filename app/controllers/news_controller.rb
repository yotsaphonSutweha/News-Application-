require 'open-uri'
require 'json'
require 'breaking_news_apis'

class NewsController < ApplicationController 
    def get_news
        @news = BreakingNewsApis.instance.get_news
        @previous_search = cookies[:previous_search]
        @previous_search = @previous_search.to_s
        @recommended_news = BreakingNewsApis.instance.recommendation(@previous_search)
    end

    def search_news 
        @search_value = params[:search_value]
        cookies[:previous_search] = @search_value
        @news = BreakingNewsApis.instance.search(@search_value)
        @news_reports = NewsReport.where({ category: @search_value})
    end
end