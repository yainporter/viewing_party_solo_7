class MovieFacade
  attr_reader :movie_service, :movie_id

  def initialize(movie_id)
    @movie_id = movie_id
    @movie_service = MovieService.new
  end

  def get_top_movies
    @movie_service.get_top_movies_service
  end

  def top_movies_info
    top_movies = []
    hash_for_movie_info = Hash.new
    data = get_top_movies[:results]
    data.each do |movie_data|
      movie_data_hash = Hash.new
      movie_data_hash[:id] = movie_data[:id]
      movie_data_hash[:title] = movie_data[:title]
      movie_data_hash[:vote_average] = movie_data[:vote_average]
      hash_for_movie_info[:movie_info] = movie_data_hash
      top_movies << hash_for_movie_info
    end
    top_movies
  end

  def make_movies(data)
    data.map{ |movie| Movie.new(movie) }
  end

  def search_movies(keyword)
    @movie_service.get_search_results_service(keyword)[:results]
  end

  def get_movie
    @movie_service.get_movie_service(@movie_id)
  end

  def movie_data
    movie_data = Hash.new
    movie_data[:movie_info] = movie_info
    movie_data[:movie_reviews] = movie_reviews_info
    movie_data[:movie_cast] = movie_cast_info
    movie_data
  end

  def get_movie_reviews
    @movie_service.get_movie_reviews_service(@movie_id)
  end

  def get_movie_cast
    @movie_service.get_movie_cast_service(@movie_id)
  end

  def movie_info
    movie_info = Hash.new
    data = get_movie

    movie_info[:id] = data[:id]
    movie_info[:title] = data[:title]
    movie_info[:genres] = data[:genres]
    movie_info[:overview] = data[:overview]
    movie_info[:runtime] = data[:runtime]
    movie_info[:vote_average] = data[:vote_average]
    movie_info
  end

  def movie_cast_info
    data = get_movie_cast[:cast].take(10)
    movie_cast_info = []
    data.each do |cast_member_data|
      movie_cast_info << { name: cast_member_data[:name], character: cast_member_data[:character]}
    end
    movie_cast_info
  end

  def movie_reviews_info
    data = get_movie_reviews[:results]
    movie_reviews_info = []
    data.each do |result|
      movie_reviews_info << { author: result[:author], content: result[:content]}
    end
    movie_reviews_info
  end

  def movie
    Movie.new(movie_data)
  end
end
