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

  def get_movie_info(id)
    movie_info_data = Hash.new
    movie_info_data[:data] = @movie_service.get_movie_service(id)
    movie_info_data[:data]
  end

  def movie_info(id)
    movie_info = Hash.new
    movie_info[:id] = get_movie_info(id)[:id]
    movie_info[:genres] = get_movie_info(id)[:genres]
    movie_info[:summary] = get_movie_info(id)[:overview]
    movie_info[:runtime] = get_movie_info(id)[:runtime]
    movie_info[:title] = get_movie_info(id)[:title]
    movie_info[:vote_average] = get_movie_info(id)[:vote_average]
    movie_info[:reviews] = get_movie_reviews(id)
    movie_info[:cast] = get_movie_cast(id)

    movie_info
  end

  def get_movie_reviews(id)
    movie_reviews_data = Hash.new
    movie_reviews_data[:data] = @movie_service.get_movie_reviews_service(id)[:results]

    movie_reviews_data[:data]
  end

  def get_movie_cast(id)
    movie_cast_data = Hash.new
    movie_cast_data[:data] = @movie_service.get_movie_cast_service(id)[:cast].take(10)
    movie_cast_data[:data]
  end
end
