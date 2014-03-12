class UsersController < ApplicationController

  def index
    if current_user 
      redirect_to '/tweets'
    else 
      render "index"
    end
  end

end
