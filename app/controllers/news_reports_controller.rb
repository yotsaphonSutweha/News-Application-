class NewsReportsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_reports = @profile.news_reports
  end

  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = @profile.news_reports.find(params[:id])
    @comments = @news_report.comments
  end

  def new
    @user = User.find(params[:user_id])
    @profile =  @user.profile
    @news_report = @profile.news_reports.build
  end

  def create 
    @user = User.find(params[:user_id])
    @createdby = @user.username
    @profile = @user.profile
    @news_report = @profile.news_reports.build(params.require(:news_report).permit(:title, :category, :content))
    @news_report.createdby = @createdby
    if @news_report.save
      redirect_to user_profile_news_report_url(@user, @profile, @news_report)
    else 
      render :action => "new"
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile 
    @news_report = @profile.news_reports.find(params[:id])
  end

  def update 
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = @profile.news_reports.find(params[:id])
    if @news_report.update_attributes(params.require(:news_report).permit(:title, :category, :content))
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
