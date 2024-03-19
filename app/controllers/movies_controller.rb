class MoviesController < ApplicationController
  def index
    @facade = MovieFacade.new
  end

  def show
    @facade = MovieFacade.new
  end
end
