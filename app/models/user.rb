class User < ApplicationRecord
   validates_presence_of :name, :email
   validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

   has_many :user_parties
   has_many :viewing_parties, through: :user_parties

   def self.all_but(id)
      User.where.not("users.id = ?", id)
   end

   def movie_ids
      viewing_parties.map(&:movie_id).uniq
   end
end
