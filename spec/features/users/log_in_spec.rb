require "rails_helper"

RSpec.describe "User Login", type: :feature do
  before(:each) do
    @user = User.create!(name: Faker::Name.name, email: "user@test.com", password: "testing", password_confirmation: "testing")
    visit "/"
  end

  describe "User Story 3/4 - Loggin In" do
    it "lets a user log in - happy path" do
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
      visit user_login_form_path

      within "#login_form" do
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")

        fill_in("Email", with: "test@test.com")
        fill_in("Password", with: "testing")

        click_button("Log In")
      end

      expect(page.current_path).to eq(user_login_form_path)
      expect(page).to have_content("Invalid email/password, try again.")
    end

    it "redirects back to log in page with password that doesn't match - sad path" do
      visit user_login_form_path

      within "#login_form" do
        expect(page).to have_field("Email")
        expect(page).to have_field("Password")

        fill_in("Email", with: "user@test.com")
        fill_in("Password", with: "tester")

        click_button("Log In")
      end

      expect(page.current_path).to eq(user_login_form_path)
      expect(page).to have_content("Invalid email/password, try again.")
    end
  end
end
