# User Model
# @desc: Class to create & fetch user data from Redis storage 

require 'redis_stream_broker'

class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  #include ActionView::Helpers

  extend ActiveModel::Naming

  SESSION_EXPIRATION = 1.week.from_now

  #attr_accessor(:id, :name, :image, :nickname)
  #TODO validations

  def self.create_with_omniauth(auth)
    @user = {
      :id => auth["uid"],
      :name => auth['info']['name'], 
      :image => auth['info']['image'],
      :nickname => auth['info']['nickname'],
      :oauth_token => auth['credentials']['token'],
      :oauth_secret => auth['credentials']['secret'],
      :session_token => User.new_token,
      :session_token_expires_at => Time.at( SESSION_EXPIRATION ).to_s,
      :created_at => Time.now.to_s
    }
    RedisStreamBroker.save_user_hash( auth["uid"], @user )
    RedisStreamBroker.add_user_stream( auth["uid"] )
    @user
  end

  def self.new_token
    SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
  end


  def self.find_by_id(id)
    @user = RedisStreamBroker.get_user_hash( id, "id", "name", "image", "nickname", "oauth_token", "oauth_secret" )
  end


  private

    ## TODO better ACL checks

    #def self._can_subscribe_to_stream stream
      #current_user.exists? and current_user.tw_id == stream.tw_id
    #end

    #def self._can_publish_to_stream stream
      #self.superclass == 'TwitterStreamWorker' 
      ##or @current_user.tw_id == stream.tw_id
    #end
  
end
