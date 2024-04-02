class MoviesController < ApplicationController
  def index
    if current_user
      @facade = MovieFacade.new(params[:id])
      @keyword = params[:keyword]
    else
      flash[:alert] = "Must be logged in"
      redirect_to login_path
    end
  end

  def show
    @facade = MovieFacade.new(params[:id])
  end
end
