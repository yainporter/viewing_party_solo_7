class Movie
  attr_reader :id,
              :title,
              :vote_average,
              :genres,
              :summary,
              :runtime,
              :reviews,
              :cast,
              :release_date,
              :poster_path

  def initialize(data)
      @id = data[:movie_info][:id]
      @title = data[:movie_info][:title]
      @vote_average = data[:movie_info][:vote_average]
      @genres = data[:movie_info][:genres]
      @summary = data[:movie_info][:overview]
      @runtime = data[:movie_info][:runtime]
      @release_date = data[:movie_info][:release_date]
      @poster_path = data[:movie_info][:poster_path]
      @reviews = data[:movie_reviews]
      @cast = data[:movie_cast]
  end

  def convert_runtime
    "#{@runtime / 60}hr #{@runtime % 60}min"
  end

  def genres_to_string
    genres = @genres.map { |genre| genre[:name] }
    genres.join(", ")
  end

  def num_of_reviews
    if @reviews.nil?
      0
    else
      @reviews.size
    end
  end
end
