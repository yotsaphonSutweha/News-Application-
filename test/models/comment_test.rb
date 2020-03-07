require 'test_helper'

class CommentTest < ActiveSupport::TestCase  
  # Happy path
  test "Should save comment relating to a news report written by a profile" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
  
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
   
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    @comment = Comment.new(comment: comments(:comment_one).comment, createdby: comments(:comment_one).createdby, sentiment: comments(:comment_one).sentiment, news_report: @news_report, profile: @profile)
    assert @comment.save
  end
  # End of Happy path

  test "Should not save without a relationship to profile and report" do 
    @comment = Comment.new(comment: comments(:comment_one).comment, createdby: comments(:comment_one).createdby, sentiment: comments(:comment_one).sentiment, news_report: nil, profile: nil)
    assert_not @comment.save
  end

  test "Should not save without the actual comment" do  
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
   
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    @comment = Comment.new(comment: '', createdby: comments(:comment_one).createdby, sentiment: comments(:comment_one).sentiment, news_report: @news_report, profile: @profile)
    assert_not @comment.save
  end

  test "Should not save without the createdby attribute" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
   
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    @comment = Comment.new(comment: comments(:comment_one).comment, createdby: '', sentiment: comments(:comment_one).sentiment, news_report: @news_report, profile: @profile)
    assert_not @comment.save
  end 

  test "Should not save without the sentiment" do 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
  
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
   
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    @comment = Comment.new(comment: comments(:comment_one).comment, createdby: comments(:comment_one).createdby, sentiment: '', news_report: @news_report, profile: @profile)
    assert_not @comment.save
  end

  test "Should not save if the comment characters exceeds 2500" do 
    @test_comment = (0...2501).map { ('a'..'z').to_a[rand(26)] }.join
 
    @user = User.new(username: users(:user_one).username, email: users(:user_one).email, encrypted_password: users(:user_one).encrypted_password)
   
    @profile = Profile.new(fname: profiles(:profile_writer).fname, sname: profiles(:profile_writer).sname, bio: profiles(:profile_writer).bio, role: profiles(:profile_writer).role, no_of_followers: profiles(:profile_writer).no_of_followers, user: @user)
  
    @news_report = NewsReport.new(title: news_reports(:news_report_one).title, category: news_reports(:news_report_one).category, content: news_reports(:news_report_one).content, profile: @profile)

    @comment = Comment.new(comment: @test_comment, createdby: comments(:comment_one).createdby, sentiment: '', news_report: @news_report, profile: @profile)
    assert_not @comment.save
  end
  # End of Unhappy path
end
