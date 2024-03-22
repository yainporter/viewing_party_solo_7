class SimilarController < ApplicationController
  def index

    @facade = MovieFacade.new(params[:movie_id], params[:user_id])
  end
end
