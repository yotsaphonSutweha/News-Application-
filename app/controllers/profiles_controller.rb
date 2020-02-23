require('sentimentanalyzer')

class ProfilesController < ApplicationController
  SentimentAnalyzer.loadProfaneWords(Rails.root.join('lib/word_bank/bad-words.csv'))
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
    if SentimentAnalyzer.profaneWordsFilter(@profile.fname) == true && SentimentAnalyzer.profaneWordsFilter(@profile.sname) == true && SentimentAnalyzer.profaneWordsFilter(@profile.bio) == true
      if @profile.save
        redirect_to user_profile_path(@user, @profile)
      else 
        render :action => "new"
      end
    else 
      redirect_to new_user_profile_url(@user), flash: { alert: "Offensive language is forbidden!" }
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

    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    if @current_profile.update_attributes(params.require(:profile).permit(:fname, :sname, :bio))
      redirect_to user_profiles_path(@current_user, @current_profile)
    else 
      redirect_to edit_user_profile_url(@current_user, @current_profile), flash: { alert: "Cannot update profile details due to internal error" }
    end
  end
end
