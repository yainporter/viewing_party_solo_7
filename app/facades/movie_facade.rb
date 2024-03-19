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

  def search_movies(keyword)
    @movie_service.get_search_results_service(keyword)[:results]
  end

  def movie_info(id)
    movie_info = []
    movie_info << { genres: @movie_service.get_movie_service(id)[:genres] }
    movie_info << { runtime: @movie_service.get_movie_service(id)[:runtime] }
    movie_info << { summary: @movie_service.get_movie_service(id)[:runtime] }
    movie_info
  end

  def movie_reviews(id)
    @movie_service.get_movie_reviews_service(id)[:results]
  end

  def movie_cast(id)
    @movie_service.get_movie_cast_service(id)[:cast].take(10)
  end
end
