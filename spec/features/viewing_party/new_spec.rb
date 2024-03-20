require 'rails_helper'

RSpec.describe 'Viewing Party New', type: :feature do
  before do
    movie_data = {
      id: 240
    }

    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    @movie = Movie.new(movie_data)

    visit new_user_movie_viewing_party_path(@user, @movie)
  end

  it "displays the movie title", :vcr do
    expect(page).to have_selector("h3", text: "Create a Movie Party for The Godfather Part II")
  end

  it "has a form to be filled out", :vcr do
    within "#form" do
      expect(page).to have_selector("h3", text: "Viewing Party Details")

      expect(page).to have_content("Duration of Party")
      expect(page).to have_field()
      expect(page).to have_content("202")
      expect(page).to have_content("Day")
      expect(page).to have_field()

      expect(page).to have_content("Start Time")
      expect(page).to have_field()

      expect(page).to have_content("Invite Other Users")
      expect(page).to have_field(type: text_area)
      expect(page).to have_button("Create Party")
    end
  end
end
