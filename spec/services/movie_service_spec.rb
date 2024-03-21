require 'rails_helper'

RSpec.describe 'Movie Service' do
  before do
    @service = MovieService.new
  end

  describe "get_top_movies_service" do
    it 'searches The MovieDB APi for top 20 movies ' do
      VCR.use_cassette("/spec/fixtures/top_rated_movies") do
        top_movies = @service.get_top_movies_service

        expect(top_movies).to be_a(Hash)
        expect(top_movies[:results].size).to eq(20)
        top_movies[:results].each do |result|
          expect(result[:title].present?).to eq true
          expect(result[:vote_average].present?).to eq true
        end
      end
    end
  end

  describe "#search_movies_service" do
    it "returns a hash of movies that match the search results" do
      VCR.use_cassette("movie_search_bad_1") do
        search_results = @service.get_search_results_service("Bad")

        expect(search_results).to be_a(Hash)
        expect(search_results[:results].size).to eq(20)
        search_results[:results].each do |movie|
          expect(movie[:title].downcase.include?("bad")).to eq true
        end
      end
    end
  end

  describe "get_movie_service" do
    it "returns the information for a Movie" do
      VCR.use_cassette("movie_show_porter") do
        movie_results = @service.get_movie_service(1090265)

        expect(movie_results).to be_a(Hash)
        expect(movie_results[:id]).to eq(1090265)
        expect(movie_results[:runtime]).to eq(82)
        expect(movie_results[:genres]).to be_an(Array)
        expect(movie_results[:overview]).to eq("An aging and mute rodeo clown struggles between macabre dreams and reality.")
      end
    end
  end

  describe "#get_movie_reviews_service" do
    it "returns the data for a Movie's reviews" do
      VCR.use_cassette("movie_reviews") do
        movie_reviews = @service.get_movie_reviews_service(240)

        expect(movie_reviews).to be_a(Hash)
        expect(movie_reviews[:total_results]).to eq(4)
        movie_reviews[:results].each do |review|
          expect(review[:author].present?).to eq(true)
          expect(review[:content].present?).to eq(true)
        end
      end
    end
  end

  describe "#get_movie_cast_service" do
    it "returns the data for cast members" do
      VCR.use_cassette("movie_cast") do
        cast_list = @service.get_movie_cast_service(240)
        expect(cast_list).to be_a(Hash)
        expect(cast_list[:cast].size).to eq(83)
      end
    end
  end
end
