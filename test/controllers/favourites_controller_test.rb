require 'test_helper'

class FavouritesControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user_one = users(:user_one) 
    @profile_writer = profiles(:profile_writer)
    @report_one = news_reports(:news_report_one)
    @report_two = news_reports(:news_report_two)
    @profile_writer.news_reports = [@report_one,  @report_two]
    @user_one.profile = @profile_writer

    @user_two = users(:user_two)
    @profile_reader = profiles(:profile_reader)
    @user_two.profile = @profile_reader
  end

  teardown do 
    @user_one = nil 
    @profile_writer = nil
    @user_two = nil
    @profile_reader = nil
    @report_one = nil
    @report_two = nil
  end

  # Happy paths
  test "should get favourites" do 
    sign_in @user_two
    get follow_url(), params: {following_id: @user_one.profile.id}

    get favourites_url()
    assert_response :success
  end
  # End of Happy paths 

  # Unhappy paths
  test "should not get favourites if not signed in" do 
    get favourites_url()
    assert_redirected_to pages_home_url()
  end
  # end of Unhappy paths
end
