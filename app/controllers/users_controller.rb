class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])

    if current_user && current_user.id == @user.id
      @movies = movies_for_show(@user)
    else
      flash[:alert] = "You must be logged in or registered to access a user's dashboard"
      redirect_to root_path
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = 'Successfully Created New User'
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to register_user_path
    end
  end

  private

  def user_params
    params[:user][:email] = params[:user][:email].downcase
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def movies_for_show(user)
    facade = MovieFacade.new
    facade.incomplete_movies(user.movie_ids)
  end
end
