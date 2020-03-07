require 'test_helper'

class NewsReportTest < ActiveSupport::TestCase

  # Happy path
  test "Should save the report owned by a profile" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
    @user.save

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
    @profile.save

    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    assert @news_report.save
  end
  # End of Happy path

  # Unhappy path
  test "Should not save the report without profile" do 
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: nil)

    assert_not @news_report.save
  end

  test "Should not save the report without a title" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
    @user.save

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
    @profile.save

    @news_report = NewsReport.new(title: '', category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    assert_not @news_report.save
  end


  test "Should not save the report without a category" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
    @user.save

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
    @profile.save

    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: '', content: news_reports(:news_report_one).content, profile: @profile)

    assert_not @news_report.save
  end

  test "Should not save the report without content" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
    @user.save

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
    @profile.save

    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: '', profile: @profile)

    assert_not @news_report.save
  end

  test "Should not save the report with a title that has more than 100 characters" do 

    @test_title = (0...1001).map { ('a'..'z').to_a[rand(26)] }.join

    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
    @user.save

    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
    @profile.save

    @news_report = NewsReport.new(title: @test_title, category: news_reports(:news_report_one).category, content: '', profile: @profile)

    assert_not @news_report.save
  end
  # End of Unhappy path
end
