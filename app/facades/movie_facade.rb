class MovieFacade
  attr_reader :movie_service

  def initialize
    @movie_service = MovieService.new
  end

  def top_movies
    @movie_service.get_top_movies[:results]
  end
end
