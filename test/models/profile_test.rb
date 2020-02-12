require 'test_helper'

class ProfileTest < ActiveSupport::TestCase

  # Happy path
  test "Should save a profile with relationship to the user Yo" do 
    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "yotsaphon", sname: "sutweha", bio: "i am a news writer", role: "Writer", user: user)
    assert profile.save
  end
  # End of happy path

  # Unhappy paths
  test "Should not save a profile without relationship to a user" do 
    profile = Profile.new(fname: "yotsaphon", sname: "sutweha", bio: "i am a news writer", role: "Writer", user: nil)
    assert_not profile.save
  end

  test "Should not save a profile without without first name" do 
    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "", sname: "sutweha", bio: "i am a news writer", role: "Writer", user: user)
    assert_not profile.save
  end

  test "Should not save a profile without second name" do 
    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "yotsaphon", sname: "", bio: "i am a news writer", role: "Writer", user: user)
    assert_not profile.save
  end

  test "Should not save a profile without bio" do 
    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "yotsaphon", sname: "sutweha", bio: "", role: "Writer", user: user)
    assert_not profile.save
  end

  test "Should not save a profile without role" do 
    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "yotsaphon", sname: "sutweha", bio: "I am a news writer", role: "", user: user)
    assert_not profile.save
  end

  test "Should not save a profile with bio over 1000 characters" do 
    test_bio = (0...1001).map { ('a'..'z').to_a[rand(26)] }.join

    user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
    user.save

    profile = Profile.new(fname: "yotsaphon", sname: "sutweha", bio: test_bio, role: "", user: user)
    assert_not profile.save
  end
  # End of unhappy paths
end
