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

  describe "#get_watch_providers_service" do
    it "returns the data for a Movie's watch providers", :vcr do
      watch_list_data = @service.get_watch_providers_service(240)
      data_keys = [:id, :results]
      us_keys = [:link, :buy, :flatrate, :rent]

      expect(watch_list_data).to be_a(Hash)
      expect(watch_list_data.keys.sort).to eq(data_keys.sort)
      expect(watch_list_data[:results]).to be_a(Hash)
      expect(watch_list_data[:results].keys.include?(:US)).to eq(true)
      expect(watch_list_data[:results][:US]).to be_a(Hash)
      expect(watch_list_data[:results][:US].keys.sort).to eq(us_keys.sort)
      expect(watch_list_data[:results][:US][:buy]).to be_an(Array)
      expect(watch_list_data[:results][:US][:flatrate]).to be_an(Array)
      expect(watch_list_data[:results][:US][:rent]).to be_an(Array)
    end
  end

  describe "get_similar_movies_service" do
    it "returns data for similar movies", :vcr do
      similar_movies_data = @service.get_similar_movies_service(240)
      data_keys = [:page, :results, :total_pages, :total_results]
      results_keys = [:adult,
                      :backdrop_path,
                      :genre_ids,
                      :id,
                      :original_language,
                      :original_title,
                      :overview,
                      :popularity,
                      :poster_path,
                      :release_date,
                      :title,
                      :video,
                      :vote_average,
                      :vote_count]

      expect(similar_movies_data).to be_a(Hash)
      expect(similar_movies_data.keys.sort).to eq(data_keys.sort)
      expect(similar_movies_data[:results]).to be_an(Array)
      expect(similar_movies_data[:results].first.keys.sort).to eq(results_keys.sort)
      similar_movies_data[:results].each do |result|
        expect(result[:id]).to be_an(Integer)
        expect(result[:title]).to be_a(String)
        expect(result[:overview]).to be_a(String)
        expect(result[:release_date]).to be_a(String)
        expect(result[:poster_path]).to be_a(String)
        expect(result[:vote_average]).to be_a(Float)
      end
    end
  end
end
