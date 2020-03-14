require 'test_helper'

class BrowseBreakingNewsWorkFlowTest < ActionDispatch::IntegrationTest
    setup do 
        # Prepare a reader-type user
        @user_one = users(:user_four)
        @profile_one = profiles(:profile_reader)
        @user_one.profile = @profile_one
        @search_value = "Sport"

        @user_two = users(:user_two)
        @profile_two = profiles(:profile_writer)
        @report_two = news_reports(:news_report_one)
        @profile_two.news_reports = [@report_two]
        @user_two.profile = @profile_two
    end

    # Happy paths
    test "The user sees a list of breaking news from two API sources" do 
        # Sign in 
        sign_in @user_one
        # The user acceses the breaking news page 
        get news_url()
        assert_response :success
        # The user should see a list breaking news from the two APIs
        assert_select "h3.heading", "Breaking news"
        assert_select "div.card" # Each card displays news from the two APIs. If the card exists, it means that the APIs successfully deliver the content.
    end

    test "The user search for particular topic for the news" do 
        # Sign in
        sign_in @user_one
        # The user acceses the breaking news page and should see the search bar 
        get news_url()
        assert_response :success
        assert_select "form.form" # form is the search bar
        # The user types in the topic that he/she wishes to search 
        get search_url(), params: {search_value: @search_value}
        # The user is brought to the search results page showing relavent news from the APIs and the news reports made by the writers
        assert_response :success
        assert_select "h1.heading", "Search news"
        # The user should sees the list of news from the APIs
        assert_select "div.card-content-container"
        assert_select "a", "Link"
        # The user should see the list of news written by the reporters inside this application
        assert_select "h5.card-title", "Title: #{@report_two.title}"
        assert_select "h6.card-subtitle", "Category: #{@report_two.category}"

        # Then if the user goes back to the breaking news page, the user should sees the recemmendation section that loads news relavent to the topic of the previous search "Sport" from another news source
        get news_url()
        assert_response :success
        assert_select "h3.heading", "Because you viewed: #{@search_value}"
    end
    # End of Happy paths 

    # Unhappy paths 
    test "The user should not see a list of breaking news from two API sources if not signed in" do 
        # Sign in 
        # The user acceses the breaking news page 
        get news_url()
        assert_redirected_to pages_home_url()
        get pages_home_url()
        assert_response :success
        assert_select "strong", "Please Sign-In"
    end

    test "The user should not be able to search if not signed in" do 
        # Sign in 
        # The user acceses the search page  
        get search_url(), params: {search_value: @search_value}
        assert_redirected_to pages_home_url()
        get pages_home_url()
        assert_response :success
        assert_select "strong", "Please Sign-In"
    end
    # End of Unhappy paths 

    teardown do 
        @user_one = nil
        @profile_one = nil
        @user_two = nil
        @profile_two = nil
        @report_two = nil
    end
end