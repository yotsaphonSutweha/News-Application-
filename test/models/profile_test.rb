require 'test_helper'

class ProfileTest < ActiveSupport::TestCase

  # Happy path
  test "Should save a profile that is Writer with a relationship to the new user Yo" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
  
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert @profile.save
  end

  test "Should save a profile that is Reader with a relationship to the new user Yo" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_reader).fname, sname: profiles(:profile_reader).sname, bio: profiles(:profile_reader).bio, role: profiles(:profile_reader).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert @profile.save
  end

  test "Should save a profile with a relationship to the user Yo and the number of follow is not zero" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:not_zero_number_of_followers).no_of_followers, user: @user)

    assert @profile.save
  end

  test "Should save a profile with a relationship to the user Yo and has one and more followees" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
  
    @followee_one = Follow.new(followee_id: follows(:followee_one).id)
    @followee_two = Follow.new(followee_id: follows(:followee_two).id)

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:not_zero_number_of_followers).no_of_followers, user: @user, follows: [@followee_one, @followee_two])

    assert @profile.save
  end

  test "Should save a profile that is a Writer with a relationship to the user Yo and has one and more news reports" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
 
    @news_report_one = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content)

    @news_report_two = NewsReport.new(title: news_reports(:news_report_two).title, category: news_reports(:news_report_two).category, content: news_reports(:news_report_two).content)

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:not_zero_number_of_followers).no_of_followers, user: @user, news_reports: [@news_report_one, @news_report_two])

    assert @profile.save
  end
  # End of happy path

  # Unhappy paths
  test "Should not save a profile without a relationship to a user" do 
    @profile = Profile.new(fname: profiles(:profile_reader).fname, sname: profiles(:profile_reader).sname, bio: profiles(:profile_reader).bio, role: profiles(:profile_reader).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: nil)
    
    assert_not @profile.save
  end

  test "Should not save a profile without a first name" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: '', sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert_not @profile.save
  end

  test "Should not save a profile without a second name" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
 
    @profile = Profile.new(fname: profiles(:profile_reader).fname, sname: '', bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert_not @profile.save
  end

  test "Should not save a profile without a bio" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: '', role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert_not @profile.save
  end

  test "Should not save a profile without a role" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: '', no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert_not @profile.save
  end

  test "Should not save a profile with bio over 1000 characters" do 
    @test_bio = (0...1001).map { ('a'..'z').to_a[rand(26)] }.join

    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: @test_bio, role: '', no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)

    assert_not @profile.save
  end
  # End of unhappy paths
end
