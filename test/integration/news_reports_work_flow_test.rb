require 'test_helper'

class NewsReportsWorkFlowTest < ActionDispatch::IntegrationTest
    setup do 
        # Prepare a user without a profile
        @user_one = users(:user_four)
        @report_one = news_reports(:news_report_one)

        # Prepare a user with profile
        @user_two = users(:user_two)
        @profile_two = profiles(:profile_writer)
        @report_two = news_reports(:news_report_two)
        @profile_two.news_reports = [@report_two]
        @user_two.profile = @profile_two
    end

    # Happy path
    test "The user creates a new profile and creates a news report. The verify if the report can be seen by the user" do 
        # The user creates the profile.
        @profile = profiles(:profile_writer)
        post user_profiles_url(@user_one.id), params: {profile: {fname: @profile.fname, sname: @profile.sname, role: @profile.role, bio: @profile.bio}}

        # After successfully finish creating profile, the user is redirected to the user's profile page. The user will be automatically signed in.
        sign_in @user_one
        assert_redirected_to user_profiles_url(@user_one.id)
       
        # The user access the create news report page.
        get new_user_profile_news_report_url(@user_one.id, @user_one.profile.id)
        assert_response :success

        # the user creates a report, the user should be redirected to the news reports page when successful.
        assert_difference("@user_one.profile.news_reports.count") do 
            post user_profile_news_reports_url(@user_one.id, @user_one.profile.id), params: {news_report: {title: @report_one.title, category: @report_one.category, content: @report_one.content}}
        end
        assert_redirected_to user_profile_news_report_url(@user_one.id,  @user_one.profile.id, @user_one.profile.news_reports[0].id)
        
        # The user should see the news report information such as title and content.
        get user_profile_news_report_url(@user_one.id,  @user_one.profile.id, @user_one.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_one.title}"
        assert_select "p", "#{@report_one.content}"
    end

    test  "The user edit the existing news report. The user should see the updated infomation regarding the news report." do 
        # The user access the news report's page.
        sign_in @user_two
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"

        # The user clicks on the edit button and is brought to the edit page.
        get edit_user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Edit news report"

        # The user updates the information. Once successfully edited, the user is brought back to the news reports page.
        assert_no_difference("@user_two.profile.news_reports.count") do 
            patch user_profile_news_report_url(@user_two.id, @user_two.profile.id), params: {news_report: {title: @report_one.title, category: @report_one.category, content: @report_one.content}}
        end
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        # The user should see the updated information. The news report is now updated to report_one's information
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_one.title}"
        assert_select "p", "#{@report_one.content}"

    end

    test  "The user delete the existing news report." do 
        # The user access the news report's page and should see the report.
        sign_in @user_two
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"

        # The user clicks on the delete button. 
        assert_difference("@user_two.profile.news_reports.count", difference = - 1) do 
            delete user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        end
        # The user is brought to the his/her news reports page and should not see the news report that was deleted
        assert_redirected_to user_profile_news_reports_url(@user_two.id,  @user_two.profile.id)
        
        get user_profile_news_reports_url(@user_two.id,  @user_two.profile.id)
        assert_response :success
        assert_select "h1.heading", "Your reports"
        assert_select "div.card-wrapper", 0 # Should be an empty list of your news reports
    end
    # End of Happy paths

    # Unhppy paths
    test "The user should see an error message if the user leaves any fields blank when the user tries to create a new news report" do 
        # The user accesses the create new report page 
        sign_in @user_two
        get new_user_profile_news_report_url(@user_two.id,  @user_two.profile.id)
        assert_response :success
        assert_select "h1.heading", "Create news report"
        assert_select "form", 1
        # The user leaves any of the fields blank 
        assert_no_difference("@user_two.profile.news_reports.count") do 
            post user_profile_news_reports_url(@user_two.id, @user_two.profile.id), params: {news_report: {title: @report_one.title, category: nil, content: nil}}
        end
         # The user should be on the same page and receive the error message at the top saying "Please do not leave the fields blank"
        assert_redirected_to new_user_profile_news_report_url(@user_two.id,  @user_two.profile.id)
        get new_user_profile_news_report_url(@user_two.id,  @user_two.profile.id)
        assert_select "h1.heading", "Create news report"
        assert_select "strong", "Please do not leave the fields blank"
    end

    test "The user should see an error message if the user leaves any fields blank when the user tries to edit an existing news report" do 
        # The user accesses the edit news report page 
        sign_in @user_two
        get edit_user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Edit news report"
        assert_select "form", 1

        # The user leaves any of the fields blank 
        assert_no_difference("@user_two.profile.news_reports.count") do 
            patch user_profile_news_report_url(@user_two.id, @user_two.profile.id), params: {news_report: {title: @report_one.title, category: nil, content: nil}}
        end
         # The user should be on the same page and receive the error message at the top saying "Please do not leave the fields blank"
        assert_redirected_to edit_user_profile_news_report_url(@user_two.id,  @user_two.profile.id)
        get edit_user_profile_news_report_url(@user_two.id,  @user_two.profile.id)
        assert_select "h1.heading", "Edit news report"
        assert_select "strong", "Please do not leave the fields blank"
    end

    test "The user with reader-type profile tries to access the create news report page and receives an error message saying -> You do not have access to this page" do
        
    end
    # End of Unhappy paths

    teardown do 
        @user_one = nil
        @report_one = nil
        @user_two = nil
        @profile_two = nil
        @report_two = nil
    end
end