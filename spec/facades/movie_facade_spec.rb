require "rails_helper"

RSpec.describe MovieFacade do
  before do
    @movies = MovieFacade.new("1")
  end

  it "should exist" do
    expect(@movies).to be_a(MovieFacade)
  end

  it "has movie_service" do
    expect(@movies.movie_service).to be_a(MovieService)
  end

  it "has a movie_id that is a number String or Integer" do
    expect(@movies.movie_id).to be_a(String)

    movie = MovieFacade.new(1)
    expect(movie.movie_id).to eq(1)
  end

  it "does not have movie_id if movie_id is NOT a number String or Integer" do
    movie = MovieFacade.new("abc")

    expect(movie.movie_id).to eq(nil)

    movie2 = MovieFacade.new(0)

    expect(movie2.movie_id).to eq(nil)
  end

  it "has a user_id that is a number String or Integer" do
    movie1 = MovieFacade.new(1, "1")
    expect(movie1.user_id).to be_a(String)

    movie2 = MovieFacade.new(1, 1)
    expect(movie2.user_id).to eq(1)
  end

  it "does not have user_id if user_id is NOT a number String or Integer" do
    movie = MovieFacade.new(2, "abc")

    expect(movie.user_id).to eq(nil)

    movie2 = MovieFacade.new(3, 0)

    expect(movie2.user_id).to eq(nil)
  end

  # describe "#get_top_movies" do
  #   it "returns a hash of information from #get_top_movie_service", :vcr do
  #     top_movies = @movies.get_top_movies

  #     keys = [:page,
  #             :results,
  #             :total_pages,
  #             :total_results]

  #     results_keys = [:adult,
  #                     :backdrop_path,
  #                     :genre_ids,
  #                     :id,
  #                     :original_language,
  #                     :original_title,
  #                     :overview,
  #                     :popularity,
  #                     :poster_path,
  #                     :release_date,
  #                     :title,
  #                     :video,
  #                     :vote_average,
  #                     :vote_count]

  #     expect(top_movies).to be_a(Hash)
  #     expect(top_movies.keys.sort).to eq(keys.sort)
  #     expect(top_movies[:page]).to be_an(Integer)
  #     expect(top_movies[:page]).to eq(1)
  #     expect(top_movies[:results]).to be_an(Array)
  #     expect(top_movies[:results].first.keys).to eq(results_keys.sort)
  #     expect(top_movies[:total_pages]).to be_an(Integer)
  #     expect(top_movies[:total_results]).to be_an(Integer)
  #   end
  # end

  # describe "#get_movie_search" do
  #   it "returns the search results from MovieService", :vcr do
  #     keys = [:page,
  #             :results,
  #             :total_pages,
  #             :total_results]

  #     results_keys = [:adult,
  #                     :backdrop_path,
  #                     :genre_ids,
  #                     :id,
  #                     :original_language,
  #                     :original_title,
  #                     :overview,
  #                     :popularity,
  #                     :poster_path,
  #                     :release_date,
  #                     :title,
  #                     :video,
  #                     :vote_average,
  #                     :vote_count]

  #     movie_results = @movies.get_movie_search("Bad")
  #     expect(movie_results).to be_a(Hash)
  #     expect(movie_results.keys.sort).to eq(keys.sort)
  #     expect(movie_results[:page]).to be_an(Integer)
  #     expect(movie_results[:page]).to eq(1)
  #     expect(movie_results[:results]).to be_an(Array)
  #     expect(movie_results[:results].first.keys).to eq(results_keys.sort)
  #     expect(movie_results[:total_pages]).to be_an(Integer)
  #     expect(movie_results[:total_results]).to be_an(Integer)
  #   end
  # end

  # describe "#get_movie" do
  #   it "returns the information for a movie", :vcr do
  #     data_keys = [
  #       :adult,
  #       :backdrop_path,
  #       :belongs_to_collection,
  #       :budget,
  #       :genres,
  #       :homepage,
  #       :id,
  #       :imdb_id,
  #       :original_language,
  #       :original_title,
  #       :overview,
  #       :popularity,
  #       :poster_path,
  #       :production_companies,
  #       :production_countries,
  #       :release_date,
  #       :revenue,
  #       :runtime,
  #       :spoken_languages,
  #       :status,
  #       :tagline,
  #       :title,
  #       :video,
  #       :vote_average,
  #       :vote_count
  #     ]
  #     facade = MovieFacade.new("1090265")
  #     movie_info = facade.get_movie

  #     expect(movie_info).to be_a(Hash)
  #     expect(movie_info.keys).to eq data_keys
  #   end
  # end

  # describe "#get_movie_reviews" do
  #   it "returns the results of movie reviews", :vcr do
  #     facade = MovieFacade.new("240")
  #     movie_reviews = facade.get_movie_reviews

  #     movie_reviews_keys = [:id, :page, :results, :total_pages, :total_results]

  #     results_keys = [:author, :author_details, :content, :created_at, :id, :updated_at, :url]

  #     expect(movie_reviews).to be_a(Hash)
  #     expect(movie_reviews.keys.sort).to eq(movie_reviews_keys.sort)
  #     expect(movie_reviews[:id]).to be_an(Integer)
  #     expect(movie_reviews[:page]).to be_an(Integer)
  #     expect(movie_reviews[:total_pages]).to be_an(Integer)
  #     expect(movie_reviews[:total_results]).to be_an(Integer)
  #     expect(movie_reviews[:results]).to be_an(Array)
  #     expect(movie_reviews[:results].first).to be_a(Hash)
  #     expect(movie_reviews[:results].first.keys.sort).to eq(results_keys.sort)
  #   end
  # end

  # describe "#get_movie_cast" do
  #   it "returns the results of a Movie's cast", :vcr do
  #     facade = MovieFacade.new("240")
  #     movie_cast = facade.get_movie_cast
  #     keys = [:id, :cast, :crew]
  #     expect(movie_cast).to be_a(Hash)
  #     expect(movie_cast.keys).to eq(keys)
  #   end
  # end

  describe "#movies_array" do
    it "returns an array of movies from top movies", :vcr do
      top_movies_info = @movies.movies_array(@movies.movie_service.get_top_movies_service)
      movies_keys = [:id, :title, :vote_average]

      expect(top_movies_info).to be_an(Array)
      expect(top_movies_info.size).to eq(20)
      top_movies_info.each do |movie_data|
        expect(movie_data).to be_a(Hash)
        expect(movie_data.keys).to eq([:movie_info])
        expect(movie_data[:movie_info]).to be_a(Hash)
        expect(movie_data[:movie_info].keys.sort).to eq(movies_keys.sort)
      end
    end

    it "returns an array of movies from search results", :vcr do
      search_movies_info = @movies.movies_array(@movies.movie_service.get_search_results_service("Bad"))

      movies_keys = [:id, :title, :vote_average]

      expect(search_movies_info).to be_an(Array)
      expect(search_movies_info.size).to eq(20)
      search_movies_info.each do |movie_data|
        expect(movie_data).to be_a(Hash)
        expect(movie_data.keys).to eq([:movie_info])
        expect(movie_data[:movie_info]).to be_a(Hash)
        expect(movie_data[:movie_info].keys.sort).to eq(movies_keys.sort)
      end
    end
  end

  describe "#movie_info" do
    it "returns the data from #get_movie and stores it", :vcr do
      facade = MovieFacade.new("240")
      movie_info = facade.movie_info
      movie_info_keys = [:id, :genres, :overview, :runtime, :vote_average, :title]

      expect(movie_info).to be_a(Hash)
      expect(movie_info.keys.sort).to eq(movie_info_keys.sort)
      expect(movie_info[:id]).to be_an(Integer)
      expect(movie_info[:runtime]).to be_an(Integer)
      expect(movie_info[:genres]).to be_an(Array)
      expect(movie_info[:overview]).to be_a(String)
      expect(movie_info[:title]).to be_a(String)
      expect(movie_info[:vote_average]).to be_a(Float)
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

  describe "#movie_cast_info" do
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

  describe "full_movie_data" do
    it "combines all the information from #movie_info, #movie_reviews_info, and #movie_cast_info", :vcr do
      facade = MovieFacade.new("240")
      movie_data = facade.full_movie_data
      keys = [:movie_info, :movie_reviews, :movie_cast]

      expect(movie_data).to be_a(Hash)
      expect(movie_data.keys.sort).to eq(keys.sort)
      expect(movie_data[:movie_reviews]).to be_an(Array)
      expect(movie_data[:movie_cast]).to be_an(Array)
      expect(movie_data[:movie_info]).to be_a(Hash)
    end
  end

  describe "#make_movies" do
    it "makes an array of movie poros", :vcr do
      movies = @movies.make_movies(@movies.movies_array(@movies.movie_service.get_top_movies_service))
      expect(movies).to be_an(Array)
      movies.each do |movie|
        expect(movie).to be_a(Movie)
        expect(movie.title.present?).to eq(true)
        expect(movie.vote_average.present?).to eq(true)
      end
    end
  end

  describe "#movie" do
    before do
      @facade = MovieFacade.new("240")
      @movie = @facade.movie
    end

    it "creates a new Movie instance", :vcr do
      expect(@movie).to be_a Movie
    end

    it "has all Movie attributes", :vcr do
      expect(@movie.id.present?).to eq(true)
      expect(@movie.title.present?).to eq(true)
      expect(@movie.vote_average.present?).to eq(true)
      expect(@movie.genres.present?).to eq(true)
      expect(@movie.summary.present?).to eq(true)
      expect(@movie.runtime.present?).to eq(true)
      expect(@movie.reviews.present?).to eq(true)
      expect(@movie.cast.present?).to eq(true)
    end
  end

  describe "#valid_number_string?" do
    it "checks the string to make sure that it is an Integer" do
      expect(@movies.valid_number_string?("123as")).to eq(false)
      expect(@movies.valid_number_string?("123")).to eq(true)
    end
  end

  describe "#valid_id?" do
    it "checks to make sure that the id passed to create MovieFacade is a number > 0" do
      expect(@movies.valid_id?("0")).to eq(false)
      expect(@movies.valid_id?("1")).to eq(true)
    end
  end

  describe "#top_20_movies" do
    it "returns 20 Movie Objects of the top 20 movies", :vcr do
      top_20_movies = @movies.top_20_movies

      expect(top_20_movies).to be_an(Array)
      top_20_movies.each do |movie|
        expect(movie).to be_a(Movie)
      end
    end
  end

  describe "#movie_search_results" do
    it "returns 20 Movie Objects of a keyword search", :vcr do
      search_results = @movies.movie_search_results("Bad")

      expect(search_results).to be_an(Array)
      search_results.each do |movie|
        expect(movie).to be_a(Movie)
        expect(movie.title.downcase.include?("bad")).to eq(true)
      end
    end
  end

  describe "#watch_providers_info" do
    it "sorts through the #get_watch_providers_service for relevant data", :vcr do
      movie = MovieFacade.new(240)
      watch_providers_info = movie.watch_providers_info
      watch_method_keys = [:buy, :rent, :flatrate]
      provider_keys = [:logo_path, :provider_name, :provider_id, :display_priority]
      expect(watch_providers_info).to be_a(Hash)
      expect(watch_providers_info.keys.sort).to eq(watch_method_keys.sort)
      expect(watch_providers_info[:buy]).to be_an(Array)
      expect(watch_providers_info[:flatrate]).to be_an(Array)
      expect(watch_providers_info[:rent]).to be_an(Array)
      expect(watch_providers_info[:buy].first.keys.sort).to eq(provider_keys.sort)
      expect(watch_providers_info[:flatrate].first.keys.sort).to eq(provider_keys.sort)
      expect(watch_providers_info[:rent].first.keys.sort).to eq(provider_keys.sort)
    end
  end

  describe "#watch_providers" do
    it "returns an Array of the information needed for different watch_providers_info", :vcr do
      movie = MovieFacade.new(240)

      watch_providers_buy = movie.watch_providers("buy")
      watch_providers_rent = movie.watch_providers("rent")
      watch_providers_flatrate = movie.watch_providers("flatrate")

      expect(watch_providers_buy).to be_an(Array)
      expect(watch_providers_rent).to be_an(Array)
      expect(watch_providers_flatrate).to be_an(Array)

      buy_keys = [:logo_path, :provider_id]
      rent_keys = [:logo_path, :provider_id]
      flatrate_keys = [:logo_path, :provider_id]

      watch_providers_buy.each do |provider|
        expect(provider).to be_a(Hash)
        expect(provider.keys).to eq(buy_keys)
        expect(provider[:logo_path]).to be_a(String)
        expect(provider[:provider_id]).to be_an(Integer)
      end

      watch_providers_rent.each do |provider|
        expect(provider).to be_a(Hash)
        expect(provider.keys).to eq(rent_keys)
        expect(provider[:logo_path]).to be_a(String)
        expect(provider[:provider_id]).to be_an(Integer)
      end

      watch_providers_flatrate.each do |provider|
        expect(provider).to be_a(Hash)
        expect(provider.keys).to eq(flatrate_keys)
        expect(provider[:logo_path]).to be_a(String)
        expect(provider[:provider_id]).to be_an(Integer)
      end
    end
  end
end
