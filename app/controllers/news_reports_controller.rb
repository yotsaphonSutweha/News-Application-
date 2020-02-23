require('sentimentanalyzer')

class NewsReportsController < ApplicationController

  SentimentAnalyzer.loadProfaneWords(Rails.root.join('lib/word_bank/bad-words.csv'))

  def index
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_reports = @profile.news_reports
  end

  def show
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile_id = @current_user.profile.id
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = @profile.news_reports.find(params[:id])
    @comments = @news_report.comments
    
  end

  def new
    @user = User.find(params[:user_id])
    @profile =  @user.profile
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    @news_report = @current_profile.news_reports.build
  end

  def create 
    @user = User.find(params[:user_id])
    @createdby = @user.username
    @profile = @user.profile
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    @createdby = @current_user.username

    @title = params[:title]
    @category = params[:category]
    @content = params[:content]

    @news_report = @current_profile.news_reports.build(params.require(:news_report).permit(:title, :category, :content))
    if SentimentAnalyzer.profaneWordsFilter(@news_report.title) == true && SentimentAnalyzer.profaneWordsFilter(@news_report.category) == true && SentimentAnalyzer.profaneWordsFilter(@news_report.content) == true
      @news_report.createdby = @createdby
      if @news_report.save
        redirect_to user_profile_news_report_url(@current_user.id, @current_profile.id, @news_report.id)
      else 
        render :action => "new"
      end
    else 
      redirect_to new_user_profile_news_report_url(@current_user.id, @current_profile), flash: { alert: "Offensive language is forbidden!" }
    end
     
  end

  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    @news_report = @current_profile.news_reports.find(params[:id])
  end

  def update 
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    @title = params[:title]
    @category = params[:category]
    @content = params[:content]
    @news_report = @current_profile.news_reports.find(params[:id])
    @createdby = @news_report.createdby
    if @news_report.update_attributes(params.require(:news_report).permit(:title, :category, :content))
      @news_report.createdby = @createdby
      redirect_to user_profile_news_report_url
    else 
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = @profile.news_reports.find(params[:id])
    @news_report.destroy
    respond_to do |format|
      format.html {redirect_to user_profile_news_reports_url }
      format.xml { head :ok }
    end
  end

  def all_reports
    @news_reports = NewsReport.order(created_at: :desc)
  end
end
