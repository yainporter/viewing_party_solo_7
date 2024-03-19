class MovieFacade
  attr_reader :movie_service, :params

  def initialize(params)
    @params = params
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

  def get_movie_info
    @movie_service.get_movie_service(@params[:id])
  end

  def movie_info
    movie_info = Hash.new
    movie_info[:id] = get_movie_info[:id]
    movie_info[:genres] = get_movie_info[:genres]
    movie_info[:summary] = get_movie_info[:overview]
    movie_info[:runtime] = get_movie_info[:runtime]
    movie_info[:title] = get_movie_info[:title]
    movie_info[:vote_average] = get_movie_info[:vote_average]
    movie_info[:reviews] = get_movie_reviews
    movie_info[:cast] = get_movie_cast

    movie_info
  end

  def movie
    Movie.new(movie_info)
  end

  def get_movie_reviews
    @movie_service.get_movie_reviews_service(params[:id])[:results]
  end

  def get_movie_cast
    @movie_service.get_movie_cast_service(params[:id])[:cast].take(10)
  end
end
