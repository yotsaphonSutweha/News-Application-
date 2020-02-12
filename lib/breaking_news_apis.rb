require 'open-uri'
require 'json'
class BreakingNewsApis
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

    def self.callingNewsApi(searchValue) 
        if searchValue != nil
            @url = 'https://newsapi.org/v2/top-headlines?'\
            'country=us&'\
            'q=' + searchValue + '&'\
            'apiKey=1eaff84b12f24c50a65899494f406fb3'
        else 
            @url = 'https://newsapi.org/v2/top-headlines?'\
            'country=us&'\
            'apiKey=1eaff84b12f24c50a65899494f406fb3'
        end
        @req = URI.open(@url)
        @responseBody = @req.read
        @responseBody = JSON.parse(@responseBody)
        return @responseBody
    end

    def self.callingGuardianApi(searchValue)
        if @searchValue != nil
            @url = 'https://content.guardianapis.com/search?q=' + searchValue + '&api-key=57c2ae96-8445-4f4a-b561-cfa25ca203f1'
        else
            @url = 'https://content.guardianapis.com/search?api-key=57c2ae96-8445-4f4a-b561-cfa25ca203f1'
        end
        @req = open(@url)
        @responseBody = @req.read
        @responseBody = JSON.parse(@responseBody)
        return @responseBody
    end

    def self.getNews
        @newsApiResponse = self.callingNewsApi(nil)
        @guardianApiResponse = self.callingGuardianApi(nil)
        if @newsApiResponse && @guardianApiResponse != nil
            @responseHash = {"combine" => true, "newsApiResponse" => @newsApiResponse, "guardianApiResponse" => @guardianApiResponse}
        else
            @responseHash = {"combine" => false }
        end

        @combinedResponse = JSON.generate(@responseHash)
        @combinedResponse = JSON[@combinedResponse]
        return @combinedResponse
    end

    def self.search(searchValue)
        @searchValue = searchValue
        @guardianApiResponse = self.callingGuardianApi(@searchValue)
        @newsApiResponse = self.callingNewsApi(@searchValue)
        @responseHash = {"newsApiSearchResponse" => @newsApiResponse, "guardianApiSearchResponse" => @guardianApiResponse}
        @combinedResponse = JSON.generate(@responseHash)
        @combinedResponse = JSON[@combinedResponse]
        return @combinedResponse
    end
end