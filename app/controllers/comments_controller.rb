require('sentimentanalyzer')

class CommentsController < ApplicationController

  # Loads the word banks for the analyzer
  SentimentAnalyzer.setFilePath(Rails.root.join('lib/word_bank/words.json'))
  SentimentAnalyzer.loadProfaneWords(Rails.root.join('lib/word_bank/bad-words.csv'))
  
  def destroy
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    # Find the comment that is being destroyed using the id
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to user_profile_news_report_url(@user, @profile, @news_report) }
      format.xml { head :ok }
    end
  
  end

  def create
    @user = User.find(params[:user_id]) # this references the user that owns the news report
    @profile = @user.profile
    @username = @user.username 

    # The current user represents the user who is logged in, to find the user ID in the session we use "session["warden.user.user.key"][0][0]"
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile

    @news_report = NewsReport.find(params[:news_report_id])
    @user_comment = params[:user_comment]
    if @user_comment == ''
      redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { notice: "Please do not leave the comment field blank" }
    else 
      if SentimentAnalyzer.profaneWordsFilter(@user_comment) == true # means the content is clean, containing no cursing words
        # Use the analyzer to determine the sentiment of the comment
        @sentiment = SentimentAnalyzer.commentSentimentAnalyzer(@user_comment)
        @comment = Comment.new(comment: @user_comment, createdby: @current_user.username, sentiment: @sentiment, profile: @current_profile, news_report: @news_report)
        if @comment.save 
          redirect_to user_profile_news_report_url(@user, @profile, @news_report)
        else
          redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { notice: "Cannot create comment due to internal error" }
        end
      else 
        redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { alert: "Offensive language is forbidden!" }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @current_user = User.find(session["warden.user.user.key"][0][0])
    @current_profile = @current_user.profile
    @news_report = NewsReport.find(params[:news_report_id])
    @comment = @news_report.comments.find(params[:id])
    @user_comment = params[:user_comment]
    if @user_comment == ''
      redirect_to edit_user_profile_news_report_comment_url(@user, @profile, @news_report, @comment), flash: { notice: "Please do not leave the comment field blank" }
    else
      if SentimentAnalyzer.profaneWordsFilter(@user_comment) == true
        @sentiment = SentimentAnalyzer.commentSentimentAnalyzer(@user_comment)
        if @comment.update(comment: @user_comment, sentiment: @sentiment)
          redirect_to user_profile_news_report_url(@user, @profile, @news_report)
        else 
          redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { notice: "Cannot update comment due to internal error" }
        end 
      else
        redirect_to user_profile_news_report_url(@user, @profile, @news_report), flash: { alert: "Offensive language is forbidden!" }
      end
    end
  end
end
