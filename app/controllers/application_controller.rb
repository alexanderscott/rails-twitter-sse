class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  private

    #FIXME should be checking against our stored session token, but this is easier for demo
    def is_authenticated?
      if current_user and !current_user[:id].nil? and !session[:id].nil? and current_user[:id] == session[:id]
        true
      else
        false
      end
    end

    # Return the session user (accessible fields)
    def current_user
      current_user ||= User.find_by_id(session[:id]) if session[:id]
    end

    helper_method :current_user, :is_authenticated?

end
