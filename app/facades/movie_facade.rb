class MovieFacade
  attr_reader :movie_service, :movie_id, :user_id

  def initialize(movie_id = nil, user_id = nil)
    @movie_service = MovieService.new
    @user_id = user_id if valid_id?(user_id)
    @movie_id = movie_id if valid_id?(movie_id)
  end

  def movies_array(service)
    # Must be in an array in order to use .map to create
    # Must be a Hash, within a Hash in order to use data[:movie_info] for the Poro creation
    movies = []
    data = service[:results]
    data.each do |movie_data|
      hash_for_movie_info = Hash.new
      movie_data_hash = Hash.new
      movie_data_hash[:id] = movie_data[:id]
      movie_data_hash[:title] = movie_data[:title]
      movie_data_hash[:vote_average] = movie_data[:vote_average]
      movie_data_hash[:overview] = movie_data[:overview]
      movie_data_hash[:release_date] = movie_data[:release_date]
      movie_data_hash[:poster_path] = http_path(movie_data[:poster_path])
      hash_for_movie_info[:movie_info] = movie_data_hash
      movies << hash_for_movie_info
    end
    movies
  end

  def movie_info
    movie_info = Hash.new
    data = @movie_service.get_movie_service(@movie_id)

    movie_info[:id] = data[:id]
    movie_info[:title] = data[:title]
    movie_info[:genres] = data[:genres]
    movie_info[:overview] = data[:overview]
    movie_info[:runtime] = data[:runtime]
    movie_info[:vote_average] = data[:vote_average]
    movie_info
  end

  def movie_cast_info
    data = @movie_service.get_movie_cast_service(@movie_id)[:cast].take(10)
    movie_cast_info = []
    data.each do |cast_member_data|
      movie_cast_info << { name: cast_member_data[:name], character: cast_member_data[:character]}
    end
    movie_cast_info
  end

  def movie_reviews_info
    data = @movie_service.get_movie_reviews_service(@movie_id)[:results]
    movie_reviews_info = []
    data.each do |result|
      movie_reviews_info << { author: result[:author], content: result[:content]}
    end
    movie_reviews_info
  end

  def full_movie_data
    movie_data = Hash.new
    movie_data[:movie_info] = movie_info
    movie_data[:movie_reviews] = movie_reviews_info
    movie_data[:movie_cast] = movie_cast_info
    movie_data
  end

  def watch_providers_info
    provider_info = Hash.new
    data = @movie_service.get_watch_providers_service(@movie_id)[:results][:US]
    provider_info[:buy] = data[:buy]
    provider_info[:flatrate] = data[:flatrate]
    provider_info[:rent] = data[:rent]
    provider_info
  end

  def watch_providers(type)
    watch_providers_array = []
    type = type.to_sym
    data = watch_providers_info[type]
    data.each do |type|
      watch_providers_array << { logo_path: http_path(type[:logo_path]), provider_id: type[:provider_id] }
    end
    watch_providers_array
  end

  def similar_movies
    make_movies(movies_array(@movie_service.get_similar_movies_service(@movie_id)))
  end

  def http_path(logo_path)
    "https://media.themoviedb.org/t/p/original#{logo_path}"
  end

  def make_movies(movies_array)
    movies_array.map{ |movie| Movie.new(movie) }
  end

  def title_and_poster_info(id)
    movie_data = Hash.new

    movie_info = Hash.new

    data = @movie_service.get_movie_service(id)
    movie_info[:id] = id
    movie_info[:title] = data[:title]
    movie_info[:poster_path] = http_path(data[:poster_path])

    movie_data = {movie_info: movie_info}
  end

  def incomplete_movies(ids)
    ids.map do |id|
      Movie.new(title_and_poster_info(id))
    end
  end

  def movie
    Movie.new(full_movie_data)
  end

  def top_20_movies
    make_movies(movies_array(@movie_service.get_top_movies_service))
  end

  def movie_search_results(keyword)
    make_movies(movies_array(@movie_service.get_search_results_service(keyword)))
  end

  def valid_id?(movie_id)
    return unless movie_id.is_a?(Integer) || valid_number_string?(movie_id)

    movie_id.to_i.positive?
  end

  def valid_number_string?(string)
    string.to_i.to_s == string
  end
end
