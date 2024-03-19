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

  describe "#get_movie_info" do
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

      expect(@movies.get_movie_info(1090265)).to be_a(Hash)
      expect(@movies.get_movie_info(1090265)[:data]).to eq(nil)
      expect(@movies.get_movie_info(1090265).keys).to eq data_keys
    end
  end

  describe "#movie_info" do
    it "returns the data from #get_movie_info and sorts it", :vcr do
      expect(@movies.movie_info(1090265)).to be_a(Hash)
      expect(@movies.movie_info(1090265)[:id]).to be_a(Integer)
      expect(@movies.movie_info(1090265)[:genres]).to be_a(Array)

      @movies.movie_info(1090265)[:genres].each do |genre|
        expect(genre).to be_a(Hash)
      end

      expect(@movies.movie_info(1090265)[:summary]).to be_a(String)
      expect(@movies.movie_info(1090265)[:runtime]).to be_a(Integer)
      expect(@movies.movie_info(1090265)[:vote_average]).to be_a(Float)
      expect(@movies.movie_info(1090265)[:reviews]).to be_an(Array)

      @movies.movie_info(1090265)[:reviews].each do |review|
        expect(review).to be_a(Hash)
      end

      expect(@movies.movie_info(1090265)[:cast]).to be_an(Array)

      @movies.movie_info(1090265)[:cast].each do |cast_member|
        expect(cast_member).to be_a(Hash)
      end
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

      review_keys = [:author, :author_details, :content, :created_at, :id, :updated_at, :url]

      movie_reviews = @movies.get_movie_reviews(240)

      expect(movie_reviews).to be_an(Array)
      movie_reviews.each do |review|
        expect(review.keys).to eq(review_keys)
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

      cast_member_keys = [:adult, :gender, :id, :known_for_department, :name, :original_name, :popularity, :profile_path, :cast_id, :character, :credit_id, :order]

      movie_cast = @movies.get_movie_cast(240)

      expect(movie_cast).to be_an(Array)
      expect(movie_cast.size).to eq(10)
      movie_cast.each do |cast_member|
        expect(cast_member.keys).to eq(cast_member_keys)
      end
    end
  end
end
