class SessionsController < ApplicationController
  def new;end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      flash[:success] = "Welcome, #{user.email}"
      redirect_to user_path(user)
    else
      flash[:error] = "Invalid email/password, try again."
      render :new
    end
  end
end
