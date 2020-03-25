require 'test_helper'

class CommentingOnNewsReportWorkFlowTest < ActionDispatch::IntegrationTest
    setup do 
        # Prepare a user with a profile
        @user_one = users(:user_four)
        @profile_one = profiles(:profile_writer_for_update)
        @user_one.profile = @profile_one
        # Prepare a user with a profile
        @user_two = users(:user_two)
        @profile_two = profiles(:profile_writer)
        @report_two = news_reports(:news_report_two)
        @profile_two.news_reports = [@report_two]
        @user_two.profile = @profile_two

        # Prepare a user with a reader type profile
        @user_three = users(:user_one)
        @profile_three_reader = profiles(:profile_reader)
        @user_three.profile = @profile_three_reader
        @comment_one = comments(:comment_one).comment
        @comment_two = comments(:comment_two).comment
    end

    # Happy path
    test "The user with reader-type profile makes a comment on a news report" do 
        # Access the news report page. 
        sign_in @user_three
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment field section for commenting.
        assert_select "div.comment-input-section", 1
        # The user makes a comment. 
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_two
            }
        end
        # The user should stays on the same page and now sees the user's comment being posted on the news report page.
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "div.comment-cards", 1
        assert_select "p.comment", @comment_two
        assert_select "p.createdby", "By: #{@user_three.username}" 
       
    end

    test "The user with reader-type profile edit a comment on a news report" do 
        sign_in @user_three
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
        # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment that the user previously made with an edit button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_three.username}" 
        assert_select "a.nav-link", "Edit"
        # The user clicks on the edit button and brought to the edit page. 
        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        # The user sees a comment field.
        assert_select "h1.heading", "Edit comment"
        assert_select "div.comment-input-section", 1
        # The user edit the comment and preses the comment button
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            put user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id), params: {
                user_comment: @comment_two
            }
        end
        # The user is then redirected back to the news report page and sees that the existing comment is being updated
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "p.comment", @comment_two
        assert_select "p.createdby", "By: #{@user_three.username}" 
        assert_select "div.comment-cards", 1
        assert_select "a.nav-link", "Edit"
    end

    test "The user with reader-type profile delete a comment on a news report" do 
        sign_in @user_three
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
        # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment that the user previously made with a delete button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_three.username}" 
        assert_select "a.nav-link", "Delete"
        # The user clicks on the delet button
        assert_difference("@user_two.profile.news_reports[0].comments.count", -1) do 
            delete user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        end
        # The user should stays on the same page and sess that the comment that was deleted is gone from the comments section.
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "div.comment-cards", 0
    end

    test "The user with writer-type profile makes a comment on a news report" do 
        # Access the news report page. 
        sign_in @user_one
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        assert_select "div.comment-input-section", 1
        # The user makes a comment. 
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_two
            }
        end
        # The user should stays on the same page and now sees the user's comment being posted on the news report page.
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "div.comment-cards", 1
        assert_select "p.comment", @comment_two
        assert_select "p.createdby", "By: #{@user_one.username}" 
    end

    test "The user with writer-type profile edit a comment on a news report" do 
        sign_in @user_one
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
         # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        assert_select "div.comment-input-section", 1
        # The user should see the comment that the user previously made with an edit button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_one.username}" 
        assert_select "a.nav-link", "Edit"
        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        # The user sees a comment field.
        assert_select "h1.heading", "Edit comment"
        assert_select "div.comment-input-section", 1
        # The user edit the comment and preses the comment button
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            put user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id), params: {
                user_comment: @comment_two
            }
        end
        # The user is then redirected back to the news report page and sees that the existing comment is being updated
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "p.comment", @comment_two
        assert_select "p.createdby", "By: #{@user_one.username}" 
        assert_select "div.comment-cards", 1
        assert_select "a.nav-link", "Edit"
    end

    test "The user with writer-type profile delete a comment on a news report" do 
        sign_in @user_one
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
        # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        assert_select "div.comment-input-section", 1
        # The user should see the comment that the user previously made with a delete button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_one.username}" 
        assert_select "a.nav-link", "Delete"
        # The user clicks on the delete button
        assert_difference("@user_two.profile.news_reports[0].comments.count", -1) do 
            delete user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        end
        # The user should stays on the same page and sess that the comment that was deleted is gone from the comments section.
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "div.comment-cards", 0
    end
    # End of Happy paths
    
    # Unhppy paths
    test "The user with reader-type profile makes a comment on a news report but leaves the comment field blank" do 
        # Access the news report page. 
        sign_in @user_three
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment field section for commenting.
        assert_select "div.comment-input-section", 1
        # The user clicks on the comment button but leaves the field blank. 
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: ''
            }
        end
        # The user should stays on the same page and now receives an error message saying "Please do not leave the comment field blank"
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "strong", "Please do not leave the comment field blank"
    end

    test "The user with reader-type profile edit a comment on a news report but leaves the comment field blank" do 
        sign_in @user_three
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
        # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment that the user previously made with an edit button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_three.username}" 
        assert_select "a.nav-link", "Edit"
        # The user clicks on the edit button and brought to the edit page. 
        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        # The user is then brought to the edit page with a comment field.
        assert_select "h1.heading", "Edit comment"
        assert_select "div.comment-input-section", 1
        # The user clicks on the comment button but leaves the field blank. 
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            put user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id), params: {
                user_comment: ''
            }
        end
        # The user should stays on the same page and now receives an error message saying "Please do not leave the comment field blank"
        assert_redirected_to edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id,  @user_two.profile.news_reports[0].comments[0].id)

        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id,  @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        assert_select "strong", "Please do not leave the comment field blank"
    end

    test "The user with writer-type profile makes a comment on a news report but leaves the comment field blank" do 
        # Access the news report page. 
        sign_in @user_one
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
         # The user should see the comment field section for commenting.
        assert_select "div.comment-input-section", 1
        # The user clicks on the comment button but leaves the field blank. 
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: ''
            }
        end
        # The user should stays on the same page and now receives an error message saying "Please do not leave the comment field blank"
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "strong", "Please do not leave the comment field blank"
    end
    
    test "The user with writer-type profile edit a comment on a news report but leaves the comment field blank" do 
        sign_in @user_one
        assert_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: @comment_one
            }
        end
        # Access the news report page. 
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment that the user previously made with an edit button.
        assert_select "p.comment", @comment_one
        assert_select "p.createdby", "By: #{@user_one.username}" 
        assert_select "a.nav-link", "Edit"
        # The user clicks on the edit button and brought to the edit page. 
        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        # The user is then brought to the edit page with a comment field.
        assert_select "h1.heading", "Edit comment"
        assert_select "div.comment-input-section", 1
        # The user clicks on the comment button but leaves the field blank. 
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            put user_profile_news_report_comment_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id, @user_two.profile.news_reports[0].comments[0].id), params: {
                user_comment: ''
            }
        end
        # The user should stays on the same page and now receives an error message saying "Please do not leave the comment field blank"
        assert_redirected_to edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id,  @user_two.profile.news_reports[0].comments[0].id)

        get edit_user_profile_news_report_comment_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id,  @user_two.profile.news_reports[0].comments[0].id)
        assert_response :success
        assert_select "strong", "Please do not leave the comment field blank"
    end
        
    test "The user makes an offensive comment on a news report" do 
        # Access the news report page. 
        sign_in @user_three
        get user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "h1.heading", "Report title in #{@report_two.title}"
        assert_select "p", "#{@report_two.content}"
        # The user should see the comment field section for commenting.
        assert_select "div.comment-input-section", 1
        # The makes an offensive comment and clicks the comment button/
        assert_no_difference("@user_two.profile.news_reports[0].comments.count") do 
            post user_profile_news_report_comments_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id), params: {
                user_comment: comments(:bad_comment).comment
            }
        end
        # The user should stays on the same page and now receives an error message saying "Offensive language is forbidden!"
        assert_redirected_to user_profile_news_report_url(@user_two.id,  @user_two.profile.id, @user_two.profile.news_reports[0].id)

        get user_profile_news_report_url(@user_two.id, @user_two.profile.id, @user_two.profile.news_reports[0].id)
        assert_response :success
        assert_select "strong", "Offensive language is forbidden!"
    end
    # End of Unhappy paths

    teardown do 
        @user_one = nil
        @report_one = nil
        @user_two = nil
        @profile_one = nil
        @profile_two = nil
        @report_two = nil
        @user_three = nil
        @profile_three_reader = nil
        @comment_one = nil
        @comment_two = nil
    end
end