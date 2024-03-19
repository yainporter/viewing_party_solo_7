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
    @id = data[:id]
    @title = data[:title]
    @vote_average = data[:vote_average]
    @genres = data[:genres]
    @summary = data[:summary]
    @runtime = (data[:runtime])
    @reviews = data[:reviews]
    @cast = data[:cast]
  end

  def convert_runtime
    "#{@runtime / 60}hr #{@runtime % 60}min"
  end
end
