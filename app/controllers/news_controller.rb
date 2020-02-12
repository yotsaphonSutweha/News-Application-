require 'open-uri'
require 'json'
require 'breaking_news_apis'
class NewsController < ApplicationController 
    def get_news
        @news = BreakingNewsApis.getNews()
    end
end