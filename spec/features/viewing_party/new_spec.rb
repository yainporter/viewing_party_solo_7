require 'rails_helper'

RSpec.describe 'Viewing Party New', type: :feature do
  before do
    movie_data = {
      movie_info: {
        id: 240
      }
    }

    @user = User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    10.times do
      User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "help", password_confirmation: "help")
    end
    @movie = Movie.new(movie_data)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit new_movie_viewing_party_path(@movie.id)
  end

  it "displays the movie title", :vcr do
    expect(page).to have_selector("h3", text: "Create a Movie Party for The Godfather Part II")
  end

  it "has a form to be filled out", :vcr do
    within "#viewing-party-form" do
      expect(page).to have_selector("h3", text: "Viewing Party Details")

      expect(page).to have_content("Duration of Party")
      expect(page).to have_field("Duration of Party", with: "202")
      expect(page).to have_field("Day", with: Date.today)
      expect(page).to have_field("Start Time", with: "19:00")
      expect(page).to have_content("Invite Other Users")
      #Is there a better way to check for checkboxes?
      expect(page).to have_css("table", id: "invitations")
      checkbox_count = all('input[type="checkbox"]').count
      expect(checkbox_count).to eq(10)
      expect(page).to have_button("Create Party")
    end
  end

  it "does not have the User's name anywhere on the page", :vcr do
    expect(page).to have_no_content(@user.name)
  end

  describe "a Viewing Party form is submitted" do
    it "creates a new Viewing Party when the form is submitted", :vcr do
      visit user_path(@user)

      expect(page).to have_no_css(".viewing_party")

      visit new_movie_viewing_party_path(@movie.id)

      page.find(:css, "#viewing_party_user_ids_#{User.second.id}").set(true)
      click_button("Create Party")

      expect(page.current_path).to eq(user_path(@user))
      expect(page).to have_css(".viewing_party", count: 1)

      within ".viewing_party" do
        expect(page).to have_content("Party Time")
        expect(page).to have_content("Host: #{@user.name}")
        expect(page).to have_content("Who's Coming?")
        expect(page).to have_css("ol")
        expect(page).to have_css("li", text: "#{@user.name}")
        expect(page).to have_css("li", text: "#{User.second.name}")
        expect(page).to have_css("li", count: 2)
      end
    end

    it "displays an error when no users are invited", :vcr do
      click_button("Create Party")

      expect(page.current_path).to eq(new_movie_viewing_party_path(@movie.id))
      expect(page).to have_content("You must invite someone, try again")
    end

    xit "displays an error when duration is less than the Movie runtime", :vcr do
      fill_in "Duration", with: 100

      page.find(:css, "#viewing_party_user_ids_#{User.second.id}").set(true)

      visit new_movie_viewing_party_path(@movie.id)
      click_button("Create Party")

      expect(page.current_path).to eq(new_movie_viewing_party_path(@movie.id))

      expect(page).to have_content("Party duration must be longer than the movie runtime, try again")
    end
  end
end
