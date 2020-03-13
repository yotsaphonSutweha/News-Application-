require('sentimentanalyzer')
class ProfilesController < ApplicationController
  # GET /users/1/profile
  def index
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @user = User.find(params[:user_id])
      @profile = @user.profile
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end
  end

  def all_profiles
    begin 
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @profiles = Profile.order(created_at: :desc)
      @followed_profiles = @current_profile.follows
      @followed_profile_ids = Array.new 
      @followed_profiles.each do | followed_profile |
        @followed_profile_ids << followed_profile.followee_id
      end
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end
  end

  #GET /users/1/profile/new
  def new
      @user = User.find(params[:user_id])
      @profile = @user.build_profile()
  end

  #POST /users/1/profile
  def create 
    @user = User.find(params[:user_id])
    @profile = @user.build_profile(params.require(:profile).permit(:fname, :sname, :bio, :role))
    @profile.no_of_followers = 0
    if @profile.save
      redirect_to user_profiles_url(@user)
    else 
      redirect_to new_user_profile_url(@user), flash: { alert: "Please provide input for every field" }
    end
  end

  #GET 
  def edit 
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @user = User.find(params[:user_id])
      @profile = Profile.find(params[:id])
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end
  end

  #PUT /users/1/profile/1
  def update
    begin
      @user = User.find(params[:user_id])
      @profile = Profile.find(params[:id])
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      if @current_profile.update_attributes(params.require(:profile).permit(:fname, :sname, :bio))
        redirect_to user_profiles_url(@current_user, @current_profile)
      else 
        redirect_to edit_user_profile_url(@current_user, @current_profile), flash: { alert: "Cannot update profile details due to internal error." }
      end
    rescue => exception 
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end
  end
end
