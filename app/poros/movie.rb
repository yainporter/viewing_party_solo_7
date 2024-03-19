class Movie
  attr_reader :id,
              :title,
              :vote_average,
              :genres,
              :summary,
              :runtime,
              :reviews,
              :cast

  def initialize(data)
    require 'pry'; binding.pry
    if data.keys.include?(:movie_info)
      @id = data[:movie_info][:id]
      @title = data[:movie_info][:title]
      @vote_average = data[:movie_info][:vote_average]
      @genres = data[:movie_info][:genres]
      @summary = data[:movie_info][:overview]
      @runtime = data[:movie_info][:runtime]
      @reviews = data[:movie_reviews]
      @cast = data[:movie_cast]
    else
      @id = data[:id]
      @title = data[:title]
      @vote_average = data[:vote_average]
      @genres = data[:genres]
      @summary = data[:summary]
      @runtime = data[:runtime]
      @reviews = data[:reviews]
      @cast = data[:cast]
    end
  end

  def convert_runtime
    "#{@runtime / 60}hr #{@runtime % 60}min"
  end

  def genres_to_string
    genres = @genres.map{|genre| genre[:name]}
    genres.join(", ")
  end

  def num_of_reviews
    if @reviews == nil
      0
    else
      @reviews.size
    end
  end
end
