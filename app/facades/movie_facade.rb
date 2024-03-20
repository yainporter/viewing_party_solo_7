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
    movies_array = data.map{ |movie|movies_array << Movie.new(movie)}
    movies_array.first.take(20)
  end

  def search_movies(keyword)
    @movie_service.get_search_results_service(keyword)[:results]
  end

  def get_movie_info
    @movie_service.get_movie_service(@params[:id])
  end

  def movie_data
    movie_data = Hash.new
    movie_data[:movie_info] = get_movie_info
    movie_data[:movie_reviews] = get_movie_reviews
    movie_data[:movie_cast] = get_movie_cast
    movie_data
  end

  def movie
    Movie.new(movie_data)
  end

  def get_movie_reviews
    @movie_service.get_movie_reviews_service(params[:id])[:results]
  end

  def get_movie_cast
    params[:id] = params[:movie_id] if params[:id] == nil
    @movie_service.get_movie_cast_service(params[:id])[:cast].take(10)
  end
end
