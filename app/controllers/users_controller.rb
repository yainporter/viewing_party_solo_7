class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @movies = movies_for_show(@user)
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = 'Successfully Created New User'
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to register_user_path
    end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      flash[:success] = "Welcome, #{user.email}"
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to login_form_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def movies_for_show(user)
    facade = MovieFacade.new
    facade.incomplete_movies(user.movie_ids)
  end
end
