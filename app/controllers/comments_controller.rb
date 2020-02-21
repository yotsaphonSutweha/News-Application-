require('sentimentanalyzer')

class CommentsController < ApplicationController

  SentimentAnalyzer.setFilePath(Rails.root.join('lib/word_bank/words.json'))
  SentimentAnalyzer.loadProfaneWords(Rails.root.join('lib/word_bank/bad-words.csv'))

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
    @user = User.find(params[:user_id]) # this references the user that owns the news report
    @profile = @user.profile # this references the profile that owns the report
    
    @current_user = User.find(session["warden.user.user.key"][0][0]) # this references the logged in user
    @username = @current_user.username 
    @current_profile = @current_user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @user_comment = params[:user_comment]
    if SentimentAnalyzer.profaneWordsFilter(@user_comment) == true # means the content is clean
      @sentiment = SentimentAnalyzer.commentSentimentAnalyzer(@user_comment)
      @comment = Comment.new(comment: @user_comment, createdby: @username, sentiment:  @sentiment, profile: @current_profile, news_report: @news_report)
      if @comment.save 
        redirect_to user_profile_news_report_url(@user, @profile, @news_report)
      else
        redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { notice: "Cannot create comment due to internal error" }
      end
    else 
      redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { alert: "Offensive language is forbidden!" }
    end
  end

  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @comment = @news_report.comments.find(params[:id])

    @user_comment = params[:user_comment]
    if SentimentAnalyzer.profaneWordsFilter(@user_comment) == true
      @sentiment = SentimentAnalyzer.commentSentimentAnalyzer(@user_comment)
      if @comment.update(comment: @user_comment, sentiment: @sentiment)
        redirect_to user_profile_news_report_url(@user, @profile, @news_report)
      else 
        redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { notice: "Cannot create comment due to internal error" }
      end 
    else
      redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { alert: "Offensive language is forbidden!" }
    end
  end
end
