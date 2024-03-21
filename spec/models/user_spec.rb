require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should allow_value('something@something.something').for(:email) }
    it { should_not allow_value('something somthing@something.something').for(:email) }
    it { should_not allow_value('something.something@').for(:email) }
    it { should_not allow_value('something').for(:email) }

  end

  describe 'associations' do
    it { should have_many :user_parties }
    it { should have_many(:viewing_parties).through(:user_parties) }
  end

  describe "class methods" do
    describe ".all_but" do
      it "returns all users but the one with the ID passed through" do
        10.times do
          User.create!(name: Faker::Name.name, email: Faker::Internet.email)
        end

        user_1 = User.create!(name: "Jan", email: "tester@test.com")
        users = User.all_but(user_1.id)

        users.each do |user|
          expect(user.id).not_to eq(user_1.id)
        end
      end
    end
  end


end
