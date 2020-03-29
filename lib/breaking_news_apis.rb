require 'open-uri'
require 'json'
require 'singleton'

class BreakingNewsApis
    
    # Making this class Singleton
    include Singleton

    def initialize()
        @searchValue = '',
        @responseBody = '',
        @req = '',
        @url = '',
        @newsApiResponse = '',
        @guardianApiResponse = '',
        @responseHash = '',
        @combinedResponse = ''
    end

    def calling_news_api(searchValue) 
        if searchValue  != ''
            @uri = 'https://newsapi.org/v2/top-headlines?country=us&q=' + searchValue + '&apiKey=1eaff84b12f24c50a65899494f406fb3'
        else 
            @uri = 'https://newsapi.org/v2/top-headlines?'\
            'country=us&'\
            'apiKey=1eaff84b12f24c50a65899494f406fb3'
        end
        @req = URI.open(@uri)
        @responseBody = @req.read
        @responseBody = JSON.parse(@responseBody)
        return @responseBody
    end

    def calling_guardian_api(searchValue)
        if searchValue != ''
            @uri = 'https://content.guardianapis.com/search?q=' + searchValue + '&api-key=57c2ae96-8445-4f4a-b561-cfa25ca203f1'
        else
            @uri = 'https://content.guardianapis.com/search?api-key=57c2ae96-8445-4f4a-b561-cfa25ca203f1'
        end
        @req = URI.open(@uri)
        @responseBody = @req.read
        @responseBody = JSON.parse(@responseBody)
        return @responseBody
    end

    def calling_news_api_recommendation(searchValue)
        if searchValue != nil
            @uri = 'https://newsapi.org/v2/top-headlines?source=bbc-news&pageSize=5&q=' + searchValue + '&apiKey=1eaff84b12f24c50a65899494f406fb3'
            @req = URI.open(@uri)
            @responseBody = @req.read
            @responseBody = JSON.parse(@responseBody)
            return @responseBody
        end
        return nil
    end

    def get_news
        @searchValue = ''
        @newsApiResponse = calling_news_api(@searchValue)
        @guardianApiResponse = calling_guardian_api(@searchValue)
        if @newsApiResponse && @guardianApiResponse != nil
            @responseHash = {"combine" => true, "newsApiResponse" => @newsApiResponse, "guardianApiResponse" => @guardianApiResponse}
        else
            @responseHash = {"combine" => false }
        end
        @combinedResponse = JSON.generate(@responseHash)
        @combinedResponse = JSON[@combinedResponse]
        return @combinedResponse
    end

    def search(searchValue)
        @searchValue = searchValue
        @newsApiResponse = calling_news_api(@searchValue)
        @guardianApiResponse = calling_guardian_api(@searchValue)
        @responseHash = {"newsApiSearchResponse" => @newsApiResponse, "guardianApiSearchResponse" => @guardianApiResponse}
        @combinedResponse = JSON.generate(@responseHash)
        @combinedResponse = JSON[@combinedResponse]
        return @combinedResponse
    end

    def recommendation(previousSearch)
        @searchValue = previousSearch
        @newsApiResponse = calling_news_api_recommendation(@searchValue)
        @responseHash = {"newsApiRecommendationResponse" => @newsApiResponse}
        @responseBody = JSON.generate(@responseHash)
        @responseBody = JSON[@responseBody]
        return @responseBody
    end
end

