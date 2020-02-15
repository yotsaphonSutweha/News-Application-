class CommentsController < ApplicationController

  def edit
    
  end


  def destroy
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to user_profile_news_report_url(@user, @profile, @news_report) }
      format.xml { head :ok }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @user_comment = params[:user_comment]
    @comment = Comment.new(comment: @user_comment, createdby: @profile.fname + ' ' + @profile.sname, sentiment: "Positive", profile: @profile, news_report: @news_report)
    if @comment.save 
      redirect_to user_profile_news_report_url(@user, @profile, @news_report)
    else
      render json: {
        error: "Cannot create comment"
      }, status: :internal_server_error
    end
  end

  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @comment = @news_report.comments.find(params[:id])
    if @comment.update(comment: params[:user_comment])
      redirect_to user_profile_news_report_url(@user, @profile, @news_report)
    end 
  end
end
