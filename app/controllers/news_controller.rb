require 'open-uri'
require 'json'
require 'breaking_news_apis'

class NewsController < ApplicationController 
    def get_news
        @news = BreakingNewsApis.instance.get_news
    end

    def search_news 
        @search_value = params[:search_value]
        @news = BreakingNewsApis.instance.search(@search_value)
        @news_reports = NewsReport.where({ category: @search_value})
    end
end