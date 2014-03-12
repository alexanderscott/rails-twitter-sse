# TweetsController
# @desc: Fetch & render user tweets via the Twitter REST API to display on initial page load. 
#        After that, the client will render new tweets emitted to it via SSE.  

require 'twitter_factory'

class TweetsController < ApplicationController

  def index
    redirect_to '/' if !is_authenticated?

    # Create the REST client and make API calls on behalf of the logged in user
    tw_rest_client = TwitterFactory.new_rest_client( current_user[:oauth_token], current_user[:oauth_secret] )

    # Fetch tweet objects and map onto our slimmed-down, validated version of the tweet
    @tweets = tw_rest_client.user_timeline(session[:id].to_i).take(20)
    @tweets.map! { |tweet| TwitterFactory::Tweet.new(tweet) }

    respond_to do |format|
      format.html
      format.json { render json: @tweets }
    end
  end

  # Provide the tweet template as a string (text) for client compiling.
  def get_tpl
    tpl_path = File.join(Rails.root, 'app', 'views', 'tweets', '_tweet_client.html.erb')
    if( !File.exists?(tpl_path) )
      render :nothing => true
    else
      tpl_file = File.open(tpl_path)
      render :text => tpl_file.read
      tpl_file.close
    end
  end


  def create
    puts params[:tweet_text]
    p params
    # Create the REST client and make API calls on behalf of the logged in user
    tw_rest_client = TwitterFactory.new_rest_client( current_user[:oauth_token], current_user[:oauth_secret] )

    if tw_rest_client.update( params[:tweet_text] )
      render :json => { :success => true }, :status => 200
    else
      render :json => { :error => "Error posting tweet" }, :status => :unprocessable_entity
    end

  end

end
