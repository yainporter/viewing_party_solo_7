class MoviesController < ApplicationController
  def index
    @facade = MovieFacade.new
  end

  def show
    
  end
end
