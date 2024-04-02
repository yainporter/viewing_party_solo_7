class SessionsController < ApplicationController
  def new;end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id #This is how you keep track of a User
      flash[:success] = "Welcome, #{user.email}"
      cookies[:message] = params[:location]

      redirect_to user_path(user)
    else
      flash[:error] = "Invalid email/password, try again."
      render :new
    end
  end

  def destroy
    session[]
  end
end
