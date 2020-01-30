require('newsapis')
require 'open-uri'
require 'json'
class NewsController < ApplicationController 
    def get_news
        @news =  NewsApisCall.getNews()
    end
end