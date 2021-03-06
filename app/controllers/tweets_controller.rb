class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
    @last10 = Tweet.last(10)
    #@user = User.find(@tweet.user_id.email)
    #@user = current_user.email
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @comments = @tweet.comments
    #refactor below.  It's ugly but it works. 
    #try Tweet.find(params[:id]).user.user_id
    @user = User.find(Tweet.find(params[:id]).user_id)
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
    # respond_to do |format|
    #   if @tweet.update(tweet_params)
    #     format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: 'edit' }
    #     format.json { render json: @tweet.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @approve = "MJ approves this message. "
    @tweet = Tweet.new(tweet_params)
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tweet }
        format.js
      elsif @tweet.tweet_text.length == 0
        format.html { render action: 'new' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
        format.js { render "blank.js.erb" }
      else
        format.html { render action: 'new' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
        format.js { render "fail.js.erb" }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:tweet_text)
    end
end
