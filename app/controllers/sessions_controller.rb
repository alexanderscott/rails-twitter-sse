# SessionsController
# @desc:  Callbacks for login, logout.  Expose omniauth-twitter response to find or create a user.

class SessionsController < ApplicationController

  # Login => find or create user and update session
  def create
    auth = request.env["omniauth.auth"]

    #NOTE Would normally log a user in automatically from cookies
    #     But for our purposes, it's easy just to re-create the user hash in Redis     
    user =  User.create_with_omniauth(auth)
    #user = User.find_by_id(auth['uid']) || User.create_with_omniauth(auth)
    session[:id] = user[:id]
    redirect_to root_url
  end

  # Logout by deleting session + cookie
  def destroy
    cookies.delete ENV['SESSION_KEY'] if cookies.signed[ ENV['SESSION_KEY'] ]
    session[:id] = nil
    redirect_to root_url
  end

  # Failed login
  def failure
    redirect_to root
  end

end
