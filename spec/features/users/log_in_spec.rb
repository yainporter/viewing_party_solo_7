require "rails_helper"

RSpec.describe "User Login", type: :feature do
  before(:each) do
    @user = User.create!(name: Faker::Name.name, email: "user@test.com", password: "testing", password_confirmation: "testing")
    visit "/"
  end

  describe "User Story 3 - Loggin In Happy Path" do
    it "lets a user log in" do
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
  end
end
