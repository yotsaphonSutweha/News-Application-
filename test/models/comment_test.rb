require 'test_helper'

class CommentTest < ActiveSupport::TestCase  
  # test "Should save comment relating to a news report written by a profile" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)
    
  #   report = NewsReport.new(title: "Football", category: "Sport", content: "Football is also known as soccer", profile: profile)

  #   comment = Comment.new(comment: "This is good", createdby: "Yo", sentiment: "Positive", news_report: report, profile: profile)
  #   assert comment.save
  # end

  # test "Should not save without a relationship to report" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)

  #   comment = Comment.new(comment: "This is good", createdby: "Yo", sentiment: "Positive", profile: profile)
  #   assert_not comment.save

  # end

  # test "Should not save without a relationship to profile and report" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   comment = Comment.new(comment: "This is good", createdby: "Yo", sentiment: "Positive")
  #   assert_not comment.save

  # end

  # test "Should not save without the actual comment" do  
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)

  #   report = NewsReport.new(title: "Football", category: "Sport", content: "Football is also known as soccer", profile: profile)

  #   comment = Comment.new(comment: "", createdby: "Yo", sentiment: "Positive", news_report: report, profile: profile)
  #   assert_not comment.save
  # end

  # test "Should not save without the created by attribute" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)

  #   report = NewsReport.new(title: "Football", category: "Sport", content: "Football is also known as soccer", profile: profile)

  #   comment = Comment.new(comment: "This is good", createdby: "", sentiment: "Positive", news_report: report, profile: profile)
  #   assert_not comment.save
  # end 

  # test "Should not save without the sentiment" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)

  #   report = NewsReport.new(title: "Football", category: "Sport", content: "Football is also known as soccer", profile: profile)

  #   comment = Comment.new(comment: "This is good", createdby: "Yo", sentiment: "", news_report: report, profile: profile)
  #   assert_not comment.save
  # end

  # test "Should not save without having any attributes" do 
  #   comment = Comment.new()
  #   assert_not comment.save
  # end

  # test "Should not save if the comment characters exceeds 2500" do 
  #   test_comment = (0...2501).map { ('a'..'z').to_a[rand(26)] }.join
 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", password: "asd45rty")
  #   user.save

  #   profile = Profile.new(fname: "yotsaphons", sname: "sutweha", bio: "i am a news writer", role: "news writer", user: user)

  #   report = NewsReport.new(title: "Football", category: "Sport", content: "Football is also known as soccer", profile: profile)

  #   comment = Comment.new(comment: test_comment, createdby: "Yo", sentiment: "This positive", news_report: report, profile: profile)
  #   assert_not comment.save
  # end
end
