require 'rails_helper'

RSpec.describe 'Viewing Party New', type: :feature do
  before do
    movie_data = {
      id: 240
    }

    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    10.times do
      User.create!(name: Faker::Name.name, email: Faker::Internet.email)
    end
    @movie = Movie.new(movie_data)

    visit new_user_movie_viewing_party_path(@user, @movie.id)
  end

  it "displays the movie title", :vcr do
    expect(page).to have_selector("h3", text: "Create a Movie Party for The Godfather Part II")
  end

  it "has a form to be filled out", :vcr do
    within "#viewing-party-form" do
      save_and_open_page
      expect(page).to have_selector("h3", text: "Viewing Party Details")

      expect(page).to have_content("Duration of Party")
      expect(page).to have_field("Duration of Party", with: "202")
      expect(page).to have_field("Day", with: Date.today)
      expect(page).to have_field("Start Time", with: "19:00")
      expect(page).to have_content("Invite Other Users")
      #Is there a better way to check for checkboxes?
      checkbox_count = all('input[type="checkbox"]').count
      expect(checkbox_count).to eq(11)
      expect(page).to have_button("Create Party")
    end
  end
end
