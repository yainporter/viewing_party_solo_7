require 'rails_helper'

RSpec.describe 'Movie Service' do
  before do
    @service = MovieService.new
  end
  describe "get_top_movies_service" do
    it 'searches The MovieDB APi for top 20 movies ' do
      json_response = File.read("spec/fixtures/top_rated_movies.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      top_movies = @service.get_top_movies_service

      expect(top_movies).to be_a(Hash)
      expect(top_movies[:results].size).to eq(20)
      top_movies[:results].each do |result|
        expect(result[:title].present?).to eq true
        expect(result[:vote_average].present?).to eq true
      end
    end
  end

  describe "#search_movies_service" do
    it "returns a hash of movies that match the search results" do
      json_response = File.read("spec/fixtures/movie_search_bad_1.json")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      search_results = @service.get_search_results_service("Bad")

      expect(search_results).to be_a(Hash)
      expect(search_results[:results].size).to eq(20)
      search_results[:results].each do |movie|
        expect(movie[:title].downcase.include?("bad")).to eq true
      end
    end
  end

  describe "get_movie_service" do
    it "returns the information for a Movie" do
      json_response = File.read("spec/fixtures/movie_show_porter.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1090265?language=en-US").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      movie_results = @service.get_movie_service(1090265)
      expect(movie_results).to be_a(Hash)
      expect(movie_results[:id]).to eq(1090265)
      expect(movie_results[:runtime]).to eq(82)
      expect(movie_results[:genres]).to be_an(Array)
      expect(movie_results[:overview]).to eq("An aging and mute rodeo clown struggles between macabre dreams and reality.")
    end
  end

  describe "#get_movie_reviews_service" do
    it "returns the data for a Movie's reviews" do
      json_response = File.read("spec/fixtures/movie_reviews.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/240/reviews?language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      movie_reviews = @service.get_movie_reviews_service(240)
      expect(movie_reviews).to be_a(Hash)
      expect(movie_reviews[:total_results]).to eq(4)
      movie_reviews[:results].each do |review|
        expect(review[:author].present?).to eq(true)
        expect(review[:content].present?).to eq(true)
      end
    end
  end

  describe "#get_movie_cast_service" do
    it "returns the data for cast members" do
      json_response = File.read("spec/fixtures/movie_cast.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/240/credits?language=en-US").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      cast_list = @service.get_movie_cast_service(240)
      expect(cast_list).to be_a(Hash)
      expect(cast_list[:cast].size).to eq(30)
    end
  end
end
