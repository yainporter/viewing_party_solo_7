class ViewingParty < ApplicationRecord
   has_many :user_parties
   has_many :users, through: :user_parties

   def find_host
      users.where("user_parties.host = true").first
   end

   def user_ids
      User.all
   end
end
