require 'test_helper'

class NewsReportControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user_one = users(:user_one) # user with two reports
    @profile_writer = profiles(:profile_writer)
    @report_one = news_reports(:news_report_one)
    @report_two = news_reports(:news_report_two)
    @profile_writer.news_reports = [@report_one,  @report_two]
    @user_one.profile = @profile_writer

    @user_two = users(:user_two) # reader user
    @profile_reader = profiles(:profile_reader)
    @user_two.profile = @profile_reader

    @user_three = users(:user_three) #user with zero report
    @profile_writer_two = profiles(:profile_writer_for_update)
    @user_three.profile = @profile_writer_two 
  end

  teardown do 
    @user_one = nil 
    @profile_writer = nil
    @report_one = nil
    @report_two = nil
    @user_three = nil
    @profile_writer_two = nil
    @user_two = nil 
    @profile_reader = nil
  end

  # Happy paths
  test "should get index" do
    sign_in @user_one
    get user_profile_news_reports_url(@user_one.id, @user_one.profile.id)
    assert_response :success
  end

  test "should get show" do
    sign_in @user_one
    get user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    assert_response :success
  end

  test "should get new" do
    sign_in @user_one
    get new_user_profile_news_report_url(@user_one.id, @user_one.profile.id)
    assert_response :success
  end

  test "should create a new report" do 
    sign_in @user_three
    assert_difference("@user_three.profile.news_reports.count") do 
      post user_profile_news_reports_url(@user_three.id, @user_three.profile.id), params: {news_report: {title: news_reports(:news_report_two).title,category: news_reports(:news_report_two).category, content: news_reports(:news_report_two).content}}
    end
    assert_redirected_to user_profile_news_report_url(@user_three.id,  @user_three.profile.id, @user_three.profile.news_reports[0].id)
  end

  test "should get edit" do
    sign_in @user_one
    get edit_user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    assert_response :success
  end

  test "should get all reports" do 
    sign_in @user_one
    get newsreports_url()
    assert_response :success
  end

  test "should update the existing report" do 
    sign_in @user_one
    assert_no_difference("@user_one.profile.news_reports.count") do 
      put user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {news_report: {title: 'hey',category: 'hey', content: 'hey'}}
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id,  @user_one.profile.id, @user_one.profile.news_reports[0].id)
  end

  test "should delete the existing report" do 
    sign_in @user_one
    assert_difference("@user_one.profile.news_reports.count", difference = - 1) do 
      delete user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    end
    assert_redirected_to user_profile_news_reports_url(@user_one.id,  @user_one.profile.id)
  end

  # End of Happy paths

  # Unhappy paths
  test "should not get index if not signed in" do
    get user_profile_news_reports_url(@user_one.id, @user_one.profile.id)
    assert_redirected_to pages_home_url()
  end

  test "should not get show if not signed in" do
    get user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    assert_redirected_to pages_home_url()
  end

  test "should not get new if not signed in" do
    get new_user_profile_news_report_url(@user_one.id, @user_one.profile.id)
    assert_redirected_to pages_home_url()
  end

  test "should not create a new report if not signed in" do 
    assert_no_difference("@user_three.profile.news_reports.count") do 
      post user_profile_news_reports_url(@user_three.id, @user_three.profile.id), params: {news_report: {title: news_reports(:news_report_one).title,category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content}}
    end
    assert_redirected_to pages_home_url()
  end

  test "should not get edit if not signed in" do
    get edit_user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    assert_redirected_to pages_home_url()
  end

  test "should not get all reports if not signed in" do 
    get newsreports_url()
    assert_redirected_to pages_home_url()
  end

  test "should not update the existing report if not signed in" do 
    assert_no_difference("@user_one.profile.news_reports.count") do 
      put user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {news_report: {title: 'hey',category: 'hey', content: 'hey'}}
    end
    assert_redirected_to pages_home_url()
  end

  test "should not delete the existing report if not signed in" do 
    assert_no_difference("@user_one.profile.news_reports.count") do 
      delete user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
    end
    assert_redirected_to pages_home_url()
  end

  test "should not get new if the profile role is Reader" do
    sign_in @user_two
    get new_user_profile_news_report_url(@user_two.id, @user_two.profile.id)
    assert_redirected_to pages_home_url()
  end

  test "should not create if the profile role is Reader" do
    sign_in @user_two
    assert_no_difference("@user_two.profile.news_reports.count") do 
      post user_profile_news_reports_url(@user_two.id, @user_two.profile.id), params: {news_report: {title: news_reports(:news_report_one).title,category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content}}
    end
    assert_redirected_to pages_home_url()
  end
  
  test "should redirect to edit page if record is not updated" do 
    sign_in @user_one
    assert_no_difference("@user_one.profile.news_reports.count") do 
      put user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {news_report: {title: 'hey',category: nil, content: nil}}
    end
    assert_redirected_to edit_user_profile_news_report_url(@user_one.id,  @user_one.profile.id, @user_one.profile.news_reports[0].id)
  end

  test "should redirect to new page if record is not saved" do 
    sign_in @user_three
    assert_no_difference("@user_three.profile.news_reports.count") do 
      post user_profile_news_reports_url(@user_three.id, @user_three.profile.id,), params: {news_report: {title: 'hey',category: nil, content: nil}}
    end
    assert_redirected_to new_user_profile_news_report_url(@user_three.id,  @user_three.profile.id)
  end
  # End of Unhappy paths
end
