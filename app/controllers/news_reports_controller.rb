require('sentimentanalyzer')

class NewsReportsController < ApplicationController

  SentimentAnalyzer.loadProfaneWords(Rails.root.join('lib/word_bank/bad-words.csv'))

  def index
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @news_reports = @profile.news_reports
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end
  end

  def show
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile_id = @current_user.profile.id
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @news_report = @profile.news_reports.find(params[:id])
      @comments = @news_report.comments
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }
    end 
  end

  def new
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @user = User.find(params[:user_id])
      @profile =  @user.profile
      if @current_profile.role == 'Reader'
        redirect_to pages_home_url(), flash: { notice: "You do not have access to this functionality. Please sign up as a Writer!" }
      else
        @news_report = @current_profile.news_reports.build
      end
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end

  def create 
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @createdby = @current_user.username
      if @current_profile.role == 'Reader'
        redirect_to pages_home_url(), flash: { notice: "You do not have access to this functionality. Please sign up as a Writer!" }
      else
        @title = params[:title]
        @category = params[:category]
        @content = params[:content]
        @news_report = @current_profile.news_reports.build(params.require(:news_report).permit(:title, :category, :content))
        @news_report.createdby = @createdby
        if @news_report.save
          redirect_to user_profile_news_report_url(@current_user.id, @current_profile.id, @news_report.id)
        else 
          redirect_to new_user_profile_news_report_url(@current_user.id, @current_profile.id), flash: { alert: "Please do not leave the fields blank" }  
        end
      end 
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end

  def edit
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @news_report = @current_profile.news_reports.find(params[:id])
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end

  def update 
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @title = params[:title]
      @category = params[:category]
      @content = params[:content]
      @news_report = @current_profile.news_reports.find(params[:id])
      @createdby = @news_report.createdby
      if @news_report.update_attributes(params.require(:news_report).permit(:title, :category, :content))
        @news_report.createdby = @createdby
        redirect_to user_profile_news_report_url
      else 
        redirect_to edit_user_profile_news_report_url(@current_user.id, @current_profile.id, @news_report.id), flash: { alert: "Please do not leave the fields blank" }  
      end

    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end

  def destroy
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @current_profile = @current_user.profile
      @user = User.find(params[:user_id])
      @profile = @user.profile
      @news_report = @profile.news_reports.find(params[:id])
      @news_report.destroy
      respond_to do |format|
        format.html {redirect_to user_profile_news_reports_url }
        format.xml { head :ok }
      end
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end

  def all_reports
    begin
      @current_user = User.find(session["warden.user.user.key"][0][0])
      @news_reports = NewsReport.order(created_at: :desc)
    rescue => exception
      redirect_to pages_home_url, flash: { alert: "Please Sign-In" }  
    end
  end
end
