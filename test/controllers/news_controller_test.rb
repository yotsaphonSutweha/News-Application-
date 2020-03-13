require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user_one = users(:user_one) # user with two reports
        @profile_writer = profiles(:profile_writer)
        @search_value = 'sport'
    end 

    teardown do 
        @user_one = nil 
        @profile_writer = nil
        @search_value = nil
      end

    # Happy paths
    # test "should get get_news" do
    #     sign_in @user_one
    #     get news_url()
    #     assert_response :success
    # end

    # test "should get search_news" do
    #     sign_in @user_one
    #     get search_url(), params: {search_value: @search_value}
    #     assert_response :success
    # end
    # # End of Happy paths

    # # Unhappy paths
    # test "should not get get_news if not signed in" do
    #     get news_url()
    #     assert_redirected_to pages_home_url()
    # end

    # test "should not get search_news if not signed in" do
    #     get search_url(), params: {search_value: @search_value}
    #     assert_redirected_to pages_home_url()
    # end
    # Unhappy of Happy paths
end
