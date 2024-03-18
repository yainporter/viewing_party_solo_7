require "rails_helper"

RSpec.describe MovieFacade do
  before do
    json_response = File.read("spec/fixtures/top_rated_movies.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
      with(
        headers: {
          "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
        }
      ).to_return(status: 200, body: json_response)
    @movies = MovieFacade.new
  end
  it "should exist" do
    expect(@movies).to be_a(MovieFacade)
  end

  it "has movie_service" do
    expect(@movies.movie_service).to be_a(MovieService)
  end

  it "can get the top_movies" do
    expect(@movies.top_movies).to be_a(Array)
    expect(@movies.top_movies.size).to eq(20)
    @movies.top_movies.each do |movie|
      expect(movie[:title].present?).to eq true
      expect(movie[:vote_average].present?).to eq true
    end
  end
end