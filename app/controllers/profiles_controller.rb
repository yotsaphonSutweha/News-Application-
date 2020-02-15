class ProfilesController < ApplicationController
  # GET /users/1/profile
  def index
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def all_profiles
    @profiles = Profile.order(created_at: :desc)
  end

  def show 
    @user = User.find(params[:user_id])
    @profile = @user.profile
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
    if @profile.save
      redirect_to user_profile_path(@user, @profile)
    else 
      render :action => "new"
    end
  end

  #GET 
  def edit 
    @user = User.find(params[:user_id])
    @profile = Profile.find(params[:id])
  end

  #PUT /users/1/profile/1
  def update
    @user = User.find(params[:user_id])
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params.require(:profile).permit(:fname, :sname, :bio, :role))
      redirect_to user_profiles_path(@user, @profile)
    else 
      render :action => "edit"
    end
  end
end
