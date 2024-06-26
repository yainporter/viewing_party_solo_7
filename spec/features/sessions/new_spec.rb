require "rails_helper"

RSpec.describe "User Login", type: :feature do
  before(:each) do
    @user = User.create!(name: Faker::Name.name, email: "user@test.com", password: "testing", password_confirmation: "testing")

    visit login_path
  end

  describe "User Story 3/4 - Loggin In" do
    it "lets a user log in - happy path" do
      visit "/"

      expect(page).to have_link("Log In")

      click_link("Log In")

      expect(page.current_path).to eq("/login")
      expect(page).to have_css("#login_form")

      within "#login_form" do
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")

        fill_in("Email", with: "user@test.com")
        fill_in("Password", with: "testing")

        click_button("Log In")
      end

      expect(page.current_path).to eq(user_path(@user))
    end

    it "redirects back to log in page with email that doesn't exist - sad path" do
      within "#login_form" do
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")

        fill_in("Email", with: "test@test.com")
        fill_in("Password", with: "testing")

        click_button("Log In")
      end

      expect(page.current_path).to eq(login_path)
      expect(page).to have_content("Invalid email/password, try again.")
    end

    it "redirects back to log in page with password that doesn't match - sad path" do
      within "#login_form" do
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")

        fill_in("Email", with: "user@test.com")
        fill_in("Password", with: "tester")

        click_button("Log In")
      end

      expect(page.current_path).to eq(login_path)
      expect(page).to have_content("Invalid email/password, try again.")
    end
  end

  describe "Part 1 - Implement a Cookie" do
    it "has a text input field for 'Location'" do
      within "#login_form" do
        expect(page).to have_field("Location", type: "text")
      end
    end

    it "displays my location on the landing page when I fill it in" do
      fill_in("Email", with: "user@test.com")
      fill_in("Password", with: "testing")
      fill_in("Location", with: "Arizona")

      click_button("Log In")

      expect(page).to have_content("Location: Arizona")
    end

    it "doesn't display my location on the landing page if empty" do
      fill_in("Email", with: "user@test.com")
      fill_in("Password", with: "testing")

      click_button("Log In")

      expect(page).to have_no_content("Location: Arizona")
    end

    it "still shows my cookie on the login page after logging out" do
      fill_in("Email", with: "user@test.com")
      fill_in("Password", with: "testing")
      fill_in("Location", with: "Arizona")

      click_button("Log In")
      click_link("Log Out")

      expect(page.current_path).to eq("/")

      visit login_path(@user)

      expect(page).to have_content("Location: Arizona")
    end
  end

  describe "Part 2 - Remember a User" do
    it "allows a user to stay logged in after leaving the site" do
      fill_in("Email", with: "user@test.com")
      fill_in("Password", with: "testing")

      click_button("Log In")

      visit "https://google.com"

      visit user_path(@user)

      expect(page).to have_content("#{@user.name}'s Dashboard")
    end
  end

  describe "Part 3 - Log out a User" do
    before do
      fill_in("Email", with: "user@test.com")
      fill_in("Password", with: "testing")

      click_button("Log In")
    end
    it "only displays a link to logout instead of log in or create new user" do
      visit "/"

      expect(page).to_not have_button("Create New User")
      expect(page).to_not have_link("Log In")
      expect(page).to have_link("Log Out")
    end

    it "can log a user out and change the landing page accordingly" do
      visit "/"

      click_link("Log Out")
      expect(page.current_path).to eq("/")
      expect(page).to have_button("Create New User")
      expect(page).to have_link("Log In")
      expect(page).to_not have_link("Log Out")
    end
  end
end
