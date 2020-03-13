require 'test_helper'

class ProfileWorkFlowTest < ActionDispatch::IntegrationTest
    setup do 
        @user_one = users(:user_one)
        @profile_one = profiles(:profile_reader)
      
        @user_two = users(:user_four)
        @profile_two = profiles(:profile_writer)

        @user_three = users(:user_three)
        @profile_three = profiles(:profile_writer_for_update)
        @user_three.profile = @profile_three

        @user_four = users(:user_five)
        @profile_four = profiles(:profile_reader)
        @user_four.profile = @profile_four
    end

    # Happy paths
    test "Create a writer profile" do 
        # Sign in after registration
        sign_in @user_two
        # On the create profile page 
        get new_user_profile_url(@user_two.id)
        assert_response :success
        # Fill out every fields and chooses writer option in role and presses create
        assert_difference("Profile.count") do 
            post user_profiles_url(@user_two.id), params: { profile: { fname: @profile_two.fname, sname: @profile_two.sname, role: @profile_two.role, bio: @profile_two.bio } }
        end
       
        # The user is redirected to the account page and can see their information
        assert_redirected_to user_profiles_url(@user_two)
        get user_profiles_url(@user_two)
        assert_response :success
        assert_select "h1.heading", "Username: #{@user_two.username}"
        assert_select "h4", "Name: #{@profile_two.fname}   #{@profile_two.sname}"
        assert_select "h5", "Role: #{@profile_two.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "#{@profile_two.bio}"
    end

    test "Edit a writer profile" do   
        sign_in @user_three
        # Access user's profile page
        get user_profiles_url(@user_three)
        assert_response :success
        # The user should see their profile information  and an edit buttom
        assert_select "h1.heading", "Username: #{@user_three.username}"
        assert_select "h4", "Name: #{@user_three.profile.fname}   #{@user_three.profile.sname}"
        assert_select "h5", "Role: #{@user_three.profile.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "#{@user_three.profile.bio}"
        assert_select "a", "Edit"
        # The user clicks on the edit button and is brought to edit page 
        get edit_user_profile_url(@user_three.id, @user_three.profile.id)
        assert_response :success
        # The user sees the edit form 
        assert_select "h1.heading", "Edit profile"
        assert_select "form", 1
        # The user makes changes to their profile information and preseses edit and is brought back to the profile page with updated information
        assert_no_difference("Profile.count") do 
            patch user_profile_url(@user_three.id, @user_three.profile.id), params: { profile: { fname: "Yotsss", sname: "Sutweha", bio: "This is bio" } }
        end
        assert_redirected_to user_profiles_url(@user_three, @user_three.profile)
        get user_profiles_url(@user_three, @user_three.profile)
        assert_response :success
        assert_select "h4", "Name: Yotsss   Sutweha"
        assert_select "h5", "Role: #{@user_three.profile.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "This is bio"
    end

    test "Create a reader profile" do 
      # Sign in after registration
      sign_in @user_one
      # On the create profile page 
      get new_user_profile_url(@user_one.id)
      assert_response :success
      # Fill out every fields and chooses writer option in role and presses create
      assert_difference("Profile.count") do 
          post user_profiles_url(@user_one.id), params: { profile: { fname: @profile_one.fname, sname: @profile_one.sname, role: @profile_one.role, bio: @profile_one.bio } }
      end
     
      # The user is redirected to the account page and can see their information
      assert_redirected_to user_profiles_url(@user_one)
      get user_profiles_url(@user_one)
      assert_response :success
      assert_select "h4", "Name: #{@profile_one.fname}   #{@profile_one.sname}"
      assert_select "h5", "Role: #{@profile_one.role}"
      assert_select "h6", "Followers: 0"
      assert_select "p", "Bio:"
      assert_select "p", "#{@profile_one.bio}"
    end

    test "Edit a reader profile" do 
        sign_in @user_four
        # Access user's profile page
        get user_profiles_url(@user_four)
        assert_response :success
        # The user should see their profile information  and an edit buttom
        assert_select "h1.heading", "Username: #{@user_four.username}"
        assert_select "h4", "Name: #{@user_four.profile.fname}   #{@user_four.profile.sname}"
        assert_select "h5", "Role: #{@user_four.profile.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "#{@user_four.profile.bio}"
        assert_select "a", "Edit"
        # The user clicks on the edit button and is brought to edit page 
        get edit_user_profile_url(@user_four.id, @user_four.profile.id)
        assert_response :success
        # The user sees the edit form 
        assert_select "h1.heading", "Edit profile"
        assert_select "form", 1
        # The user makes changes to their profile information and preseses edit and is brought back to the profile page with updated information
        assert_no_difference("Profile.count") do 
            patch user_profile_url(@user_four.id, @user_four.profile.id), params: { profile: { fname: "Hey", sname: "Heyyo", bio: "This is hey" } }
        end
        assert_redirected_to user_profiles_url(@user_four, @user_four.profile)
        get user_profiles_url(@user_four, @user_four.profile)
        assert_response :success
        assert_select "h4", "Name: Hey   Heyyo"
        assert_select "h5", "Role: #{@user_four.profile.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "This is hey"
    end
    # End of Happy paths 

    # Unhappy paths
    test "The user receives a notification if he/she leaves any field blank when creating a profile" do 
        # Signed in after registration
        sign_in @user_two
        # On the create profile page 
        get new_user_profile_url(@user_two.id)
        assert_response :success
        # The user leaves some of the input fields blank and presses create
        assert_no_difference("Profile.count") do 
            post user_profiles_url(@user_two.id), params: { profile: { fname: '', sname: '', role: @profile_two.role, bio: @profile_two.bio } }
        end
       # The user stays on the same page and should see the notification
       assert_redirected_to new_user_profile_url(@user_two.id)
       get new_user_profile_url(@user_two.id)
       assert_response :success
       assert_select "h1.heading", "Create profile"
       assert_select "strong", "Please provide input for every field"
    end

    test "The user receives a notification if he/she leaves any field blank when editing a profile" do 
        # Access user's profile page
        sign_in @user_three
        get user_profiles_url(@user_three)
        assert_response :success
        # The user should see their profile information 
        assert_select "h1.heading", "Username: #{@user_three.username}"
        assert_select "h4", "Name: #{@user_three.profile.fname}   #{@user_three.profile.sname}"
        assert_select "h5", "Role: #{@user_three.profile.role}"
        assert_select "h6", "Followers: 0"
        assert_select "p", "Bio:"
        assert_select "p", "#{@user_three.profile.bio}"
        assert_select "a", "Edit"
        # The user clicks on the edit button and is brought to edit page 
        get edit_user_profile_url(@user_three.id, @user_three.profile.id)
        assert_response :success
        # The user sees the edit form 
        assert_select "h1.heading", "Edit profile"
        assert_select "form", 1
        # TThe user leaves some of the input fields blank and presses edit
        assert_no_difference("Profile.count") do 
            patch user_profile_url(@user_three.id, @user_three.profile.id), params: { profile: { fname: "", sname: "", bio: "This is bio" } }
        end
        # The user stays on the same page and should see the notification
        assert_redirected_to edit_user_profile_url(@user_three, @user_three.profile)
        get edit_user_profile_url(@user_three, @user_three.profile)
        assert_response :success
        assert_select "h1.heading", "Edit profile"
        assert_select "strong", "Cannot update profile details due to internal error."
    end

    test "The user cancels creating a profile" do 
        # Signed in after registration
        sign_in @user_two
        # On the create profile page 
        get new_user_profile_url(@user_two.id)
        assert_response :success
        # The user sees the cancel button on the navigation bar
        assert_select "a", "Cancel"
        # The user clicks the cancel button 
        delete user_registration_url()
        # The user is brought back to the home page
        assert_redirected_to '/'
    end
    # End of Unhappy paths

    teardown do 
        @user_one = nil
        @report_one = nil
        @user_two = nil
        @profile_two = nil
        @report_two = nil
        @user_three = nil 
        @profile_three = nil
        @user_four = nil 
        @profile_four = nil
    end
end