require 'rails_helper'

RSpec.describe 'Movie Service' do
  describe "get_top_movies" do
    it 'searches The MovieDB APi for movies ' do
      json_response = File.read("spec/fixtures/top_rated_movies.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1").
        to_return(status: 200, body: json_response)

      service = MovieService.new
      require 'pry'; binding.pry
      service.get_top_movies
    end
  end
end
