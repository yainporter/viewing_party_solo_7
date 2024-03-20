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
    @movies = MovieFacade.new("1")
  end

  it "should exist" do
    expect(@movies).to be_a(MovieFacade)
  end

  it "has movie_service" do
    expect(@movies.movie_service).to be_a(MovieService)
  end

  it "has a movie_id" do
    expect(@movies.movie_id).to be_a(String)
  end

  describe "#top_movies" do
    it "can get the top_movies" do
      expect(@movies.top_movies).to be_an(Array)
      expect(@movies.top_movies.size).to eq(20)
      @movies.top_movies.each do |movie|
        expect(movie[:title].present?).to eq true
        expect(movie[:vote_average].present?).to eq true
      end
    end
  end

  describe "#make_top_movies" do
    it "makes an array of movie poros" do
      movies = @movies.make_movies(@movies.top_movies)
      expect(movies).to be_an(Array)
      movies.each do |movie|
        expect(movie).to be_a(Movie)
        expect(movie.title.present?).to eq(true)
        expect(movie.vote_average.present?).to eq(true)
      end
    end
  end

  describe "#search_movies" do
    it "returns the search results from MovieService" do
      json_response = File.read("spec/fixtures/movie_search_bad_1.json")

      stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Bad&include_adult=false&language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      movie_results = @movies.search_movies("Bad")
      expect(movie_results).to be_an(Array)
      expect(movie_results.size).to eq(20)
      movie_results.each do |movie|
        expect(movie[:title].present?).to eq(true)
        expect(movie[:vote_average].present?).to eq(true)
      end
    end
  end

  describe "#get_movie" do
    it "returns the information for a movie" do
      json_response = File.read("spec/fixtures/movie_show_porter.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1090265?language=en-US").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      data_keys = [
        :adult,
        :backdrop_path,
        :belongs_to_collection,
        :budget,
        :genres,
        :homepage,
        :id,
        :imdb_id,
        :original_language,
        :original_title,
        :overview,
        :popularity,
        :poster_path,
        :production_companies,
        :production_countries,
        :release_date,
        :revenue,
        :runtime,
        :spoken_languages,
        :status,
        :tagline,
        :title,
        :video,
        :vote_average,
        :vote_count
      ]
      facade = MovieFacade.new("1090265")
      movie_info = facade.get_movie

      expect(movie_info).to be_a(Hash)
      expect(movie_info.keys).to eq data_keys
    end
  end

  describe "#movie_info" do
    it "returns the data from #get_movie and stores it", :vcr do
      facade = MovieFacade.new("240")
      movie_info = facade.movie_info
      movie_info_keys = [:id, :genres, :overview, :runtime, :vote_average]

      expect(movie_info).to be_a(Hash)
      expect(movie_info.keys.sort).to eq(movie_info_keys.sort)
      expect(movie_info[:id]).to be_an(Integer)
      expect(movie_info[:runtime]).to be_an(Integer)
      expect(movie_info[:genres]).to be_an(Array)
      expect(movie_info[:overview]).to be_a(String)
      expect(movie_info[:vote_average]).to be_a(Float)

    end
  end

  describe "#get_movie_reviews" do
    it "returns the results of movie reviews" do
      json_response = File.read("spec/fixtures/movie_reviews.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/240/reviews?language=en-US&page=1").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      facade = MovieFacade.new("240")
      movie_reviews = facade.get_movie_reviews

      movie_reviews_keys = [:id, :page, :results, :total_pages, :total_results]

      results_keys = [:author, :author_details, :content, :created_at, :id, :updated_at, :url]

      expect(movie_reviews).to be_a(Hash)
      expect(movie_reviews.keys.sort).to eq(movie_reviews_keys.sort)
      expect(movie_reviews[:id]).to be_an(Integer)
      expect(movie_reviews[:page]).to be_an(Integer)
      expect(movie_reviews[:total_pages]).to be_an(Integer)
      expect(movie_reviews[:total_results]).to be_an(Integer)
      expect(movie_reviews[:results]).to be_an(Array)
      expect(movie_reviews[:results].first).to be_a(Hash)
      expect(movie_reviews[:results].first.keys.sort).to eq(results_keys.sort)
    end
  end

  describe "#movie_reviews_info" do
    it "returns an array of necessary data from #get_movie_reviews", :vcr do
      facade = MovieFacade.new("240")
      movie_reviews_info = facade.movie_reviews_info

      expect(movie_reviews_info).to be_an(Array)
      movie_reviews_info.each do |review_info|
        expect(review_info).to be_a(Hash)
        expect(review_info.keys).to eq([:author, :content])
        expect(review_info[:author]).to be_a(String)
        expect(review_info[:content]).to be_a(String)
      end
    end
  end

  describe "#get_movie_cast" do
    it "returns the results of a Movie's cast" do
      json_response = File.read("spec/fixtures/movie_cast.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/240/credits?language=en-US").
        with(
          headers: {
            "Authorization": ENV["TMDB_ACCESS_TOKEN_KEY"]
          }
        ).to_return(status: 200, body: json_response)

      facade = MovieFacade.new("240")
      movie_cast = facade.get_movie_cast
      keys = [:id, :cast, :crew]
      expect(movie_cast).to be_a(Hash)
      expect(movie_cast.keys).to eq(keys)
    end
  end

  describe "#get_movie_cast_info" do
    it "organizes the data from #get_movie_cast into only wanted data", :vcr do
      facade = MovieFacade.new("240")
      movie_cast_info = facade.movie_cast_info

      expect(movie_cast_info).to be_an (Array)
      expect(movie_cast_info.size).to eq(10)
      movie_cast_info.each do |cast_member_data|
        expect(cast_member_data).to be_a(Hash)
        expect(cast_member_data.keys).to eq([:name, :character])
        expect(cast_member_data[:name]).to be_a(String)
        expect(cast_member_data[:character]).to be_a(String)
      end
    end
  end

  describe "movie_data" do
    it "combines all the information from movie_info, movie_reviews, and movie_cast", :vcr do
      facade = MovieFacade.new("240")
      movie_data = facade.movie_data
      keys = [:movie_info, :movie_reviews, :movie_cast]

      expect(movie_data.keys.sort).to eq(keys.sort)
      expect(movie_data).to be_a(Hash)
      expect(movie_data[:movie_reviews]).to be_an(Array)
      expect(movie_data[:movie_cast]).to be_an(Array)
      expect(movie_data[:movie_info]).to be_a(Hash)
    end
  end

  describe "#movie" do
    it "creates a new Movie instance", :vcr do
      facade = MovieFacade.new("240")
      movie = facade.movie
      expect(movie).to be_a Movie
    end
  end
end
