require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index page" do
    get user_profile_news_report_comments_url(id: 1, news_report_id: 1, profile_id: 1, user_id: 1)
    assert_response :success
  end

  test "should get new page" do
    get new_user_profile_news_report_comment_url(id: 1, news_report_id: 1, profile_id: 1, user_id: 1)
    assert_response :success
  end

  test "should get edit page" do
    get edit_user_profile_news_report_comment_url(id: 1, news_report_id: 1, profile_id: 1, user_id: 1)
    assert_response :success
  end

  test "should get show page" do
    get user_profile_news_report_comment_url(id: 1, news_report_id: 1, profile_id: 1, user_id: 1)
    assert_response :success
  end

  test "should create a comment" do
    post user_profile_news_report_comments_url(news_report_id: 1, profile_id: 1, user_id: 1)
    assert_response :success
  end

end
