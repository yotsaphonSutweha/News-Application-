require_relative './../breaking_news_apis.rb'
require "test/unit"

class BreakingNewsApisTest < Test::Unit::TestCase

    def test_newsapi_call
        assert_not_nil(BreakingNewsApis.instance.calling_news_api(''))
    end

    def test_guardianapi_call
        assert_not_nil(BreakingNewsApis.instance.calling_guardian_api(''))
    end

    def test_newsapi_status_state
        response = BreakingNewsApis.instance.calling_news_api('')
        responseStatusCode = response
        assert_equal("ok", response["status"], "Test if the GET request is successful")
    end

    def test_guardianapi_status_state
        response = BreakingNewsApis.instance.calling_guardian_api('')
        responseStatusCode = response
        assert_equal("ok", responseStatusCode["response"]["status"], "Test if the GET request is successful")
    end

    def test_combined_api_responses
        combinedResponse = BreakingNewsApis.instance.get_news
        combineStatus = combinedResponse["combine"]
        assert_equal(true, combineStatus, "Test if the two JSON responses are combined into one JSON object")
    end

    def test_search
        searchValueForTest = "Sport"
        searchResponse = BreakingNewsApis.instance.search(searchValueForTest)
        assert_not_nil(searchResponse)
    end
end