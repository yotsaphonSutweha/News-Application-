require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @user_one = users(:user_one) # user with two reports
    @profile_writer = profiles(:profile_writer)
    @report_one = news_reports(:news_report_one)
    @report_two = news_reports(:news_report_two)
    @profile_writer.news_reports = [@report_one,  @report_two]
    @user_one.profile = @profile_writer
    @user_two = users(:user_two)
    @profile_reader = profiles(:profile_reader)
    @user_two.profile = @profile_reader
    sign_in @user_one
    post user_profile_news_report_comments_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id), params: {
      user_comment: comments(:comment_one).comment
    }
  end

  teardown do 
    @user_two = nil
    @user_one = nil 
    @profile_writer = nil
    @report_one = nil
    @report_two = nil
  end
  
  # Happy paths 
  test "should create a comment" do
    assert_difference("@user_one.profile.news_reports[0].comments.count") do 
      post user_profile_news_report_comments_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {
          user_comment: comments(:comment_one).comment
      }
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
  end

  test "should update an existing comment" do
    assert_no_difference("@user_one.profile.news_reports[1].comments.count") do 
      patch user_profile_news_report_comment_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id, @user_one.profile.news_reports[1].comments[0].id), params: {
          user_comment: comments(:comment_two).comment
      }
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id)
  end

  test "should delete an existing comment" do
    assert_difference("@user_one.profile.news_reports[1].comments.count", difference = -1) do 
      delete user_profile_news_report_comment_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id, @user_one.profile.news_reports[1].comments[0].id)
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id)
  end
  # End of Happy paths

  # Unhappy paths
  test "should not create a comment if there is an internal server error" do
    assert_no_difference("@user_one.profile.news_reports[0].comments.count") do 
      post user_profile_news_report_comments_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {
          user_comment: ''
      }
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
  end

  test "should not update an existing comment if there is an internal server error" do
    assert_no_difference("@user_one.profile.news_reports[1].comments.count") do 
      patch user_profile_news_report_comment_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id, @user_one.profile.news_reports[1].comments[0].id), params: {
          user_comment: ''
      }
    end
    assert_redirected_to edit_user_profile_news_report_comment_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id, @user_one.profile.news_reports[1].comments[0].id)
  end

  test "should not create a comment if it contains cursing words" do
    assert_no_difference("@user_one.profile.news_reports[0].comments.count") do 
      post user_profile_news_report_comments_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id), params: {
          user_comment: comments(:bad_comment).comment
      }
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[0].id)
  end

  test "should not update an existing comment if it contains cursing words" do
    assert_no_difference("@user_one.profile.news_reports[1].comments.count") do 
      patch user_profile_news_report_comment_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id, @user_one.profile.news_reports[1].comments[0].id), params: {
          user_comment: comments(:bad_comment).comment
      }
    end
    assert_redirected_to user_profile_news_report_url(@user_one.id, @user_one.profile.id, @user_one.profile.news_reports[1].id)
  end
  # End of Unhappy paths
end
