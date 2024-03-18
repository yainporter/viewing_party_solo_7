class MovieFacade
  attr_reader :movie_service

  def initialize
    @movie_service = MovieService.new
  end

  def top_movies
    @movie_service.get_top_movies_service[:results]
  end

  def make_movies(data)
    movies_array = []
    data.each do |movie|
      movies_array << Movie.new(movie)
    end
    movies_array
  end
end
