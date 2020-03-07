require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # Happy path
  test "Should save follow with a relationship to profile" do 
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
   
    @follow = Follow.new(followee_id: follows(:followee_one).id, profile:  @profile)

    assert @follow.save
  end
  # End of Happy path

  # Unhappy path
  test "Should not save without a relationship to profile" do 
    @follow = Follow.new(followee_id: follows(:followee_one).id, profile: nil)

    assert_not @follow.save
  end

  test "Should not save without a followee_id" do 
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
  
    @follow = Follow.new(followee_id: '', profile:  @profile)
    
    assert_not @follow.save
  end
  # End of Unhappy path
end
