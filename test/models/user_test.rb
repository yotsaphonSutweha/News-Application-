require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # Happy path
  test "Should save the user with username, email and password with correct password and email format" do
    @user = users(:user_one)
    assert @user.save
  end

  # End of Happy path

  # Unhappy path
  # test "Should not save the user without username" do 
  #   @user = users(:user_two)
  #   assert_not @user.save
  # end

  # test "Should not save the user without email" do 
  #   user = User.new(username: "Yo", email: "", encrypted_password: "yotsaphoN2019", encrypted_password_confirmation: "yotsaphoN2019")
  #   assert_not user.save
  # end

  # test "Should not save the user without password and confirming password" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "", encrypted_password_confirmation: "")
  #   assert_not user.save
  # end

  # test "Should not save the user if email does not conform to @...mail.com format" do 
  #   user = User.new(username: "Yo", email: "yogmailcom", encrypted_password: "yotsaphoN2019", encrypted_password_confirmation: "yotsaphoN2019")
  #   assert_not user.save
  # end

  # test "Should not save the user if password and password_confirmation are not the same " do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "yotsaphoN2019", encrypted_password_confirmation: "yotsaphoN2018")
  #   assert_not user.save
  # end

  # test "Should not save the user if password is less than 8 characters" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "aD12345", encrypted_password_confirmation: "aD12345")
  #   assert_not user.save
  # end

  # test "Should not save the user if password does not contain at least one number" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "yotsaphonN", encrypted_password_confirmation: "yotsaphonN")
  #   assert_not user.save
  # end

  # test "Should not save the user if password does not contain at least one lowercase character" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "YOTSAPHON2019", encrypted_password_confirmation: "YOTSAPHON2019")
  #   assert_not user.save
  # end
  
  # test "Should not save the user if password does not contain at least one uppercase character" do 
  #   user = User.new(username: "Yo", email: "yo@gmail.com", encrypted_password: "yotsaphon2019", encrypted_password_confirmation: "yotsaphon2019")
  #   assert_not user.save
  # end
  #End of Unhappy path
end
