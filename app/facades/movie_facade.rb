class MovieFacade
  attr_reader :movie_service, :movie_id

  def initialize(movie_id)
    @movie_id = movie_id
    @movie_service = MovieService.new
  end

  def top_movies
    @movie_service.get_top_movies_service[:results]
  end

  def make_movies(data)
    movies_array = data.map{ |movie| Movie.new(movie) }
  end

  def search_movies(keyword)
    @movie_service.get_search_results_service(keyword)[:results]
  end

  def get_movie_info
    @movie_service.get_movie_service(@movie_id)
  end

  def movie_data
    movie_data = Hash.new
    movie_data[:movie_info] = movie_info
    movie_data[:movie_reviews] = movie_reviews_data
    movie_data[:movie_cast] = movie_cast_data
    movie_data
  end

  def movie
    Movie.new(movie_data)
  end

  def get_movie_reviews
    @movie_service.get_movie_reviews_service(@movie_id)
  end

  def get_movie_cast
    @movie_service.get_movie_cast_service(@movie_id)
  end

  def movie_info
    movie_info = Hash.new
    data = get_movie_info

    movie_info[:id] = data[:id]
    movie_info[:genres] = data[:genres]
    movie_info[:overview] = data[:overview]
    movie_info[:runtime] = data[:runtime]
    movie_info[:vote_average] = data[:vote_average]
    movie_info
  end

  def movie_cast_data
    data = get_movie_cast[:cast].take(10)
    movie_cast_data = []
    data.each do |cast_member_data|
      movie_cast_data << { name: cast_member_data[:name], character: cast_member_data[:character]}
    end
    movie_cast_data
  end

  def movie_reviews_data
    data = get_movie_reviews[:results]
    movie_reviews_data = []
    data.each do |result|
      movie_reviews_data << { author: result[:author], content: result[:content]}
    end
    movie_reviews_data
  end
end
