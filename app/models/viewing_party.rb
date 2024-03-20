class ViewingParty < ApplicationRecord
   has_many :user_parties
   has_many :users, through: :user_parties
   after_save { create_user_parties("create") }

   def find_host
      users.where("user_parties.host = true").first
   end

   def user_ids
      User.all
   end

   def create_user_parties(params)
    require 'pry'; binding.pry
    params[:viewing_party][:user_ids].map do |user_id|
      user_parties.create!(user_id: user_id, host: false) if user_id != ""
    end
    user_parties.create!(user_id: params[:user_id], host: true)
   end
end
