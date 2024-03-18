require 'rails_helper'

RSpec.describe 'Movie Service' do
  describe "get_top_movies" do
    it 'searches The MovieDB APi for top 20 movies ' do
      json_response = File.read("spec/fixtures/top_rated_movies.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      service = MovieService.new
      top_movies = service.get_top_movies

      expect(top_movies).to be_a(Hash)
      expect(top_movies[:results].size).to eq(20)
      top_movies[:results].each do |result|
        expect(result[:title].present?).to eq true
        expect(result[:vote_average].present?).to eq true
      end
    end
  end
end
