require 'test_helper'

class FollowingWriterWorkFlowTest < ActionDispatch::IntegrationTest
    setup do 
        # Prepare a reader-type user
        @user_one = users(:user_four)
        @profile_one = profiles(:profile_reader)
        @user_one.profile = @profile_one

        # Prepare a user with profile and a report
        @user_two = users(:user_two)
        @profile_two = profiles(:profile_writer)
        @report_two = news_reports(:news_report_two)
        @profile_two.news_reports = [@report_two]
        @user_two.profile = @profile_two
    end

    test "Follow another user and see their posts in personal favourites page" do 
        # The user signs in
        sign_in @user_one
        # User goes to news writers page where there is a list of news writer profiles being displayed
        get newswriters_url()
        assert_response :success
        # The user should sees two profiles, one for him/herself and another one for the other user.
        assert_select "h5.card-title", "#{@user_one.profile.fname}  #{@user_one.profile.sname}"
        assert_select "h5.card-title", "#{@user_two.profile.fname}  #{@user_two.profile.sname}"
        # The user can see the follow button. The user clicks on the follow button.
        assert_select "a", "Follow"
        get follow_url(), params: {following_id: @user_two.profile.id}
        assert_redirected_to newswriters_url(@user_one.id)
        get newswriters_url() 
        assert_response :success
        # The user receives a notification stating that the user successfully followed another user 
        assert_select "strong", "Follow successful"
        # The user should see that the follow button is no replaced with "Followed" red text, stating that the user has successfully followed another user.
        assert_select "p", "Followed"
        # The user goes to favourites page and see the news report post that was written by another user
        get favourites_url()
        assert_response :success
        assert_select "h1.heading", "From your favourite reporters"
        assert_select "div.card-body", 1
        assert_select "h5.card-title", "Title: #{@report_two.title}"
        assert_select "h6.card-subtitle", "Category: #{@report_two.category}"
        assert_select "p", "#{@report_two.content}"
        assert_select "a", "Read more"
    end

    teardown do 
        @user_one = nil
        @report_one = nil
        @user_two = nil
        @profile_two = nil
        @report_two = nil
    end
end