require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_one = users(:user_one) # user with profile
    @user_two = users(:user_two) # user without profile
    @profile = profiles(:profile_writer)
    @user_one.profile = @profile
    @user_three = users(:user_three) 
    @profile_two = profiles(:profile_reader)
    @user_three.profile = @profile_two
    @user_four = users(:user_four)
  end

  # Happy paths
  test "should get index" do
    sign_in @user_one
    get user_profiles_url(@user_one.id)
    assert_response :success
  end

  test "should get new" do
    get new_user_profile_url(@user_two.id)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user_one
    get edit_user_profile_url(@user_one.id, @user_one.profile.id)
    assert_response :success
  end

  test "should get newswriters page" do
    sign_in @user_one
    get newswriters_url()
    assert_response :success
  end

  test "should create a new profile" do
    assert_difference("Profile.count") do 
      post user_profiles_url(@user_two.id), params: { profile: { fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, role: profiles(:profile_writer).role, bio: profiles(:profile_writer).bio } }
    end
    assert_redirected_to user_profiles_url(@user_two)
  end

  test "should update the existing profile" do
    sign_in @user_one
    assert_no_difference("Profile.count") do 
      put user_profile_url(@user_one.id, @user_one.profile.id), params: { profile: { fname: "Yotsss", sname: "Sutweha", bio: "I am koolest" } }
    end
    assert_redirected_to user_profiles_url(@user_one, @profile)
  end
  # End of happy paths

  # Unhappy paths
  test "should redirect to home page if on the profile page without signing in" do
    get user_profiles_url(@user_three.id)
    assert_redirected_to(pages_home_url)
  end

  test "should redirect to home page if on the edit profile page without signing in" do
    get edit_user_profile_url(@user_three.id, @user_three.profile.id)
    assert_redirected_to(pages_home_url)
  end

  test "should redirect to home page if on the newswriters page without signing in" do
    get newswriters_url()
    assert_redirected_to(pages_home_url)
  end

  test "should redirect to new page if record is not saved" do 
    assert_no_difference("Profile.count") do 
      post user_profiles_url(@user_four.id), params: { profile: { fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, role: nil, bio: nil} }
    end
    assert_redirected_to(new_user_profile_url(@user_four.id))
  end

  test "should redirect to edit page if record is not updated" do 
    sign_in @user_one
    assert_no_difference("Profile.count") do 
      put user_profile_url(@user_one.id, @user_one.profile.id), params: { profile: { fname: "Yotsss", sname: "Sutweha", bio: nil} }
    end
    assert_redirected_to(edit_user_profile_url(@user_one.id, @user_one.profile.id))
  end
  # End of unhappy paths

  teardown do 
    @user_one = nil 
    @user_two = nil # user without profile
    @profile = nil
    @user_three = nil
    @user_four = nil
    @profile_two = nil
  end
end
