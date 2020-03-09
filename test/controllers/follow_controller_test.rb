require 'test_helper'

class FollowControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user_one = users(:user_one)
        @profile_writer = profiles(:profile_writer)
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
    end

    # Happy paths
    test "Should follow" do 
        sign_in @user_one
        get follow_url(), params: {following_id: @user_two.profile.id}
        assert_redirected_to newswriters_url(@user_one)
    end
    # End of Happy paths 

    # Unhappy paths
    test "Should not follow if not signed in" do 
        get follow_url(), params: {following_id: @user_two.profile.id}
        assert_redirected_to pages_home_url()
    end
    # End of Unhappy paths
end
