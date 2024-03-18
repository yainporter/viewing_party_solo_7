class MovieService
  def conn
    Faraday.new(url: "https://api.themoviedb.org/3") do |faraday|
      faraday.headers["Authorization"] = ENV["TMDB_ACCESS_TOKEN_KEY"]
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_top_movies
    get_url("https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1")
  end
end
