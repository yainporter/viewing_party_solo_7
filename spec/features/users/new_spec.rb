require 'rails_helper'

RSpec.describe 'Register', type: :feature do

  describe 'When user visits "/register"' do
    before(:each) do
      @user = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "help", password_confirmation: "help")
      @user = User.create!(name: 'Sam', email: 'sam@email.com', password: "help", password_confirmation: "help")

      visit register_user_path
    end

    it 'They see a Home link that redirects to landing page' do

      expect(page).to have_link('Home')

      click_link "Home"

      expect(current_path).to eq(root_path)
    end

    it 'They see a form to fill in their name, email, password, and password confirmation' do
      expect(page).to have_field("user[name]")
      expect(page).to have_field('user[email]')
      expect(page).to have_selector(:link_or_button, 'Register')
    end

    it 'When they fill in the form with their name and email then they are taken to their dashboard page "/users/:id"' do
      fill_in "user[name]", with: 'Chris'
      fill_in "user[email]", with: 'chris@email.com'
      fill_in "user[password]", with: 'test'
      fill_in "user[password_confirmation]", with: 'test'

      click_button 'Register'

      new_user = User.last

      expect(current_path).to eq(user_path(new_user))
      expect(page).to have_content('Successfully Created New User')
    end

    it 'when they fill in form with information, email (non-unique), submit, redirects to user show page' do
      fill_in "user[name]", with: 'Tommy'
      fill_in "user[email]", with: 'tommy@email.com'

      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email has already been taken')
    end

    it 'when they fill in form with missing information' do
      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""
      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content("Name can't be blank, Email can't be blank")
    end

    it 'They fill in form with invalid email format (only somethng@something.something)' do
      fill_in "user[name]", with: "Sam"
      fill_in "user[email]", with: "sam sam@email.co.uk"

      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@email..com"
      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@emailcom."
      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@emailcom@"
      click_button 'Register'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')
    end


    describe "User Story 1 - Registration(w/ Authentication)" do
      it "authenticates a User successfully" do
        expect(page).to have_css("#registration_form")

        within "#registration_form" do
          expect(page).to have_field("Name")
          expect(page).to have_field("Email")
          expect(page).to have_field("Password")
          expect(page).to have_field("Confirm Password")
          expect(page).to have_button("Register")

          fill_in("user[name]", with: "User")
          fill_in("user[email]", with: "User@test.com")
          fill_in("user[password]", with: "testing")
          fill_in("user[password_confirmation]", with: "testing")
          click_button("Register")
        end
        user = User.last

        expect(page.current_path).to eq(user_path(user))
      end

      it "will give an error if name is blank" do
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testing")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Name can't be blank")
      end

      it "will give an error if email is blank" do
        fill_in("user[name]", with: "User")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testing")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Email can't be blank")
      end

      it "will give an error if password is blank" do
        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password_confirmation]", with: "testinger")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Password can't be blank")
        expect(page).to_not have_content("Password digest can't be blank")
      end

      it "will give an error if password is blank" do
        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password]", with: "testinger")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Password confirmation can't be blank")
      end

      it "will give an error if passwords don't match" do
        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testinger")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it "will give an error if an email is not unique - sad path" do
        user = User.create!(name: Faker::Name.name, email: "user@test.com", password: "testing", password_confirmation: "testing")

        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "user@test.com")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testing")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Email has already been taken")
      end

      it "will make sure that email is downcased - sad path" do
        user = User.create!(name: Faker::Name.name, email: "user@test.com", password: "testing", password_confirmation: "testing")

        fill_in("user[name]", with: "User")
        fill_in("user[email]", with: "User@test.com")
        fill_in("user[password]", with: "testing")
        fill_in("user[password_confirmation]", with: "testing")
        click_button("Register")

        expect(page.current_path).to eq("/register")
        expect(page).to have_content("Email has already been taken")
      end
    end
  end
end
