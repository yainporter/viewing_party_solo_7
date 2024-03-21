class MoviesController < ApplicationController
  def index
    @facade = MovieFacade.new(params[:id], params[:user_id])
    @keyword = params[:keyword]
  end

  def show
    @facade = MovieFacade.new(params[:id], params[:user_id])
  end
end
